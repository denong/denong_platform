# == Schema Information
#
# Table name: bank_cards
#
#  id                 :integer          not null, primary key
#  bankcard_no        :string(255)
#  id_card            :string(255)
#  name               :string(255)
#  phone              :string(255)
#  card_type          :integer
#  sn                 :string(255)
#  bank               :integer
#  bind_state         :integer
#  bind_time          :datetime
#  customer_id        :integer
#  created_at         :datetime
#  updated_at         :datetime
#  res_msg            :string(255)
#  stat_desc          :string(255)
#  bank_name          :string(255)
#  card_type_name     :string(255)
#  stat_code          :string(255)
#  res_code           :string(255)
#  certification_type :string(255)
#  bank_id            :integer
#

class BankCard < ActiveRecord::Base
  require 'openssl'
  require 'base64'
  require 'cgi'

  belongs_to :customer

  scope :success, -> { where(stat_code: ["00", "02"]) }

  def self.add_bank_card params
    # 需要四个参数, user_id, card, mobile, name
    bank_card = self.find_or_create_by(bankcard_no: params[:card], customer_id: params[:user_id])
    # if bank_card.res_code == "2004" # 银行卡正在绑定中，因此需要手动失败一次
    #   response = MultiJson.load RestClient.post("http://121.40.62.252:3000/auth/finish", params.to_json, content_type: :json, accept: :json)
    #   logger.info "bank card finish response is:#{response}"
    # end

    # result = MultiJson.load RestClient.post("http://121.40.62.252:3000/auth/card", params.to_json, content_type: :json, accept: :json)

    result = BankCard.new.verify_bank_card_from_xt params

    logger.info "bank card bind result is: #{result}"
    puts "bank card bind result is: #{result}"
    if result.present? && result["result"].present?

      if params[:auth_type].to_i == 1
        bank_card.certification_type = "sms"
      elsif params[:auth_type].to_i == 4
        bank_card.certification_type = "small_amount"
      end

      bank_card_info = find_info params[:card]
      bank_card.bank_name = bank_card_info.try(:bank)

      if bank_card.bank_name.present?
        bank = Bank.find_by(name:bank_card.bank_name)
        if bank.present?
          bank_card.bank_id = bank.id
          bank.bank_card_amount += 1
          bank.save
        end
      end
      bank_card.card_type_name = bank_card_info.try(:card_type)

      bank_card.name = params[:name]
      bank_card.res_msg = result["result"]["resMsg"] if result["result"]["resMsg"]
      bank_card.stat_desc = result["result"]["statDesc"] if result["result"]["statDesc"]
      bank_card.stat_code = result["result"]["stat"] if result["result"]["stat"]
      bank_card.res_code = result["result"]["resCode"] if result["result"]["resCode"]
      bank_card.save

      logger.info "bank card is:#{bank_card}"
    end
    bank_card
  end

  def self.filter bank_cards
    bank_card_hash = {}
    bank_cards.each do |bank_card|
      bank_card_hash[bank_card.bankcard_no] = bank_card
    end
    bank_card_hash.values
  end

  def self.send_msg params
    # 需要三个参数, user_id, card, answer
    result = MultiJson.load RestClient.post('http://121.40.62.252:3000/auth/answer', params.to_json, content_type: :json, accept: :json)
    logger.info "bank card answer result is: #{result}"

    bank_card = self.find_by bankcard_no: params[:card], customer_id: params[:user_id]
    if bank_card.present? && result.present? && result["result"].present?
      # if bank_card.stat_code != "00"
        bank_card.res_msg = result["result"]["resMsg"] if result["result"]["resMsg"]
        bank_card.stat_desc = result["result"]["statDesc"] if result["result"]["statDesc"]
        bank_card.stat_code = result["result"]["stat"] if result["result"]["stat"]
        bank_card.res_code = result["result"]["resCode"] if result["result"]["resCode"]
        bank_card.save
      # end
    end
    bank_card
  end

  def self.find_info bank_card_number
    bank_card_info = find_info_by_place(bank_card_number, 5) || find_info_by_place(bank_card_number, 4) || find_info_by_place(bank_card_number, 3)
  end

  def verify_bank_card_from_xt params
    merchId = '000072'
    tranDate = Time.zone.now.strftime("%Y%m%d")
    tranId = Time.zone.now.strftime("%H%M%S")
    tranTime = Time.zone.now.strftime("%H%M%S")
    acctNo = params[:card]
    acctName = params[:name]
    certNo = params[:id_card]
    phone = ""

    key = ""
    key = key<<merchId<<tranDate<<tranId<<tranTime<<acctNo<<acctName<<certNo<<phone

    signature = EncryptRsa.process(key)
    verify_url = "#{xt_base_url}/uapi/verify/bankcard/v1"
    params =  {"merchId" => merchId, "tranDate" => tranDate, "tranId" => tranId, "tranTime" => tranTime, "acctNo" => acctNo, "acctName" => acctName, "certNo" => certNo, "signature" => signature}

    conn = Faraday.new(:url => "#{xt_base_url}") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.post "#{xt_base_url}/uapi/verify/bankcard/v1?tranTime=#{tranTime}&tranDate=#{tranDate}&acctNo=#{acctNo}&acctName=#{acctName}&phone=#{phone}&certNo=#{certNo}&tranId=#{tranId}&merchId=#{merchId}&signature=#{signature}"

    result = MultiJson.load response.body
    p result

    result
  end

  def verify_bank_card_from_dq params
    params = VerifyParams.new
    params.api_name = "daqian.pay.verify_card"
    params.bp_id = "998800001126149"
    params.api_key = "real_7788000015920364527"
    params.bp_order_id = Time.zone.now.strftime("%Y%m%d%H%M%S")
    params.user_name = "于子洵"
    params.cert_type = "a"
    params.cert_no = "330726199110011333"
    # params.card_no = "6228480030810636313"
    params.card_no = "6226620607696580"
    params.user_mobile = "18516107607"

    verify_url = "#{dq_base_url}api/api.do"
    params = params.to_json
    signature = EncryptRsa.process(params)
    signature = signature.delete("\n")
    signature = CGI.escape(signature)

    conn = Faraday.new(:url => "#{dq_base_url}") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
    p "signature: #{signature}"
    params = CGI.escape(params)
    request_params = "data=#{params}&sign=#{signature}&sign_type=RSA&version=1.0"

    response = conn.post "#{dq_base_url}api/api.do?#{request_params}"

    result = MultiJson.load response.body
    data = result["data"]
    data = URI::decode data
    data = MultiJson.load data
    p data
    # result
  end

  def URLDecode(str)
    str.gsub!(/%[a-fA-F0-9]{2}/) { |x| x = x[1..2].hex.chr }
  end

  private
    def dq_base_url
      "http://121.40.208.138:7080/"
    end

    def xt_base_url
      "http://test.trust-one.com/trust-gateway/"
    end

    def self.find_info_by_place bank_card_number, place
      bin = bank_card_number.to_s[0..place]
      BankCardInfo.find_by bin: bin
    end

    def check_customer
      user = User.find_or_create_by phone:phone do |user|
        user.sms_token = "989898"
        user.password = "12345678"
      end
      self.customer = user.customer
    end
end
