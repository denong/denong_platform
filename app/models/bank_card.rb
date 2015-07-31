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
  belongs_to :customer

  scope :success, -> { where(stat_code: ["00", "02"]) }

  def self.add_bank_card params
    # 需要四个参数, user_id, card, mobile, name
    bank_card = self.find_or_create_by(bankcard_no: params[:card], customer_id: params[:user_id])
    # if bank_card.res_code == "2004" # 银行卡正在绑定中，因此需要手动失败一次
    #   response = MultiJson.load RestClient.post("http://121.40.62.252:3000/auth/finish", params.to_json, content_type: :json, accept: :json)
    #   logger.info "bank card finish response is:#{response}"
    # end

    result = MultiJson.load RestClient.post("http://121.40.62.252:3000/auth/card", params.to_json, content_type: :json, accept: :json)
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

  def verify_bank_card_from_xt
    merchId = '000072'
    tranDate = Time.zone.now.strftime("%Y%m%d")
    tranId = Time.zone.now.strftime("%H%M%S")
    tranTime = Time.zone.now.strftime("%H%M%S")
    acctNo = "6228480030810636313"
    acctName = "汤志荣"
    certNo = "31011519840329383X"
    phone = "13761964217"

    key = ""
    key = key<<merchId<<tranDate<<tranId<<tranTime<<acctNo<<acctName<<certNo<<phone
    p key
    # signature = EncryptRsa.new().private_encrypt(key)
    signature = EncryptRsa.process(key)
    p signature
    verify_url = "#{xt_base_url}uapi/verify/bankcard/v1"
    params =  {"merchId" => merchId, "tranDate" => tranDate, "tranId" => tranId, "tranTime" => tranTime, "acctNo" => acctNo, "acctName" => acctName, "certNo" => certNo, "phone" => phone, "signature" => signature}
    # p params
    # p "#{verify_url}"

    conn = Faraday.new(:url => 'http://test.trust-one.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.post "http://test.trust-one.com/trust-gateway/uapi/verify/bankcard/v1?tranTime=#{tranTime}&tranDate=#{tranDate}&phone=#{phone}&acctNo=#{acctNo}&acctName=#{acctName}&certNo=#{certNo}&tranId=#{tranId}&merchId=#{merchId}&signature=#{signature}"
    # response = conn.post verify_url, params

    result = MultiJson.load response.body
    p result
    # result = MultiJson.load RestClient.post(verify_url, params)
    # signature = "1CC7E9ACD10A3898ECF5FFE529F3E5E3E749C178CF689A51DB73AD0DEB8A7B6599E62BA82EC99ACF72B692819E5E9E3DD59075A708DB04008562DB6C536168109E1340E815060D46A947A80D7EA040083ABC19E5641B1DAA10BFC25430F038398AEC4B7C8CE62F925EC757048FC491D6AB19E5E1755C243ED06724C3B4DF74C3"
    # verify_url = "#{xt_base_url}uapi/verify/id/v1?merchId=000001&tranDate=20150416&tranId=888&tranTime=123030&name=张三&certNo=310115198501174210&signature=#{signature}"
    # result = MultiJson.load RestClient.post(URI.parse(verify_url), "")

    # p result
    nil
  end

  private
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
