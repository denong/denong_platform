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
#  bank_card_type     :integer
#

class BankCard < ActiveRecord::Base
  require 'openssl'
  require 'base64'
  require 'cgi'

  # debit_card: 借记卡, credit_card: 信用卡
  enum bank_card_type: { debit_card: 0, credit_card: 1}

  belongs_to :customer
  belongs_to :bank
  after_create :update_bank_infomation
  validates_presence_of :bank_id
  validates_presence_of :bank_card_type

  scope :success, -> { where(stat_code: ["00", "02"]) }

  def self.verify_bank_card params
    bank_card = BankCard.find_or_create_by(bank_id: params[:bank_id], bank_card_type: params[:bank_card_type].to_i, customer_id: params[:customer_id], bankcard_no: params[:card], phone: params[:phone])

    # 数据是否完整
    unless params[:name].present? && params[:id_card].present? && params[:card].present?
      bank_card.errors.add(:message, "信息不全")
      return bank_card
    end

    # 银行是否存在
    bank = Bank.find_by_id(params[:bank_id])
    unless bank.present?
      bank_card.errors.add(:message, "该银行不存在")
      return bank_card 
    end

    bank_card_info = find_info(params[:card])
    # 验证银行是否正确
    bank_card.bank_name = bank_card_info.try(:bank)
    if bank_card.bank_name.present? && (bank.name == bank_card.bank_name)
      bank_card.bank_id = bank.id
    else
      error_message = get_errors(bank.name, params[:bank_card_type]) 
      bank_card.errors.add(:message, error_message)
      return bank_card
    end

    # 验证卡的类型是否正确
    bank_card.card_type_name = bank_card_info.try(:card_type)
    if bank_card.card_type_name.present? && (bank_card.card_type_name.include? "借记卡") && (params[:bank_card_type].to_i == 0 || params[:bank_card_type] == "debit_card")
      bank_card.bank_card_type = params[:bank_card_type].to_i
    elsif bank_card.card_type_name.present? && !(bank_card.card_type_name.include? "借记卡") && (params[:bank_card_type].to_i == 1 || params[:bank_card_type] == "credit_card")
      bank_card.bank_card_type = params[:bank_card_type].to_i
    else
      error_message = get_errors(bank.name, params[:bank_card_type]) 
      bank_card.errors.add(:message, error_message)
      return bank_card
    end

    # 查询验证历史
    bank_card_verify_info = BankCardVerifyInfo.find_by(name: params[:name], id_card: params[:id_card], bank_card: params[:card])
    if bank_card_verify_info.present?
      case bank_card_verify_info.result
      when 0  #验证成功
        bank_card.errors.add(:message, "该银行卡已认证过")
        return bank_card
      when 1  #身份信息错误
        bank_card.errors.add(:message, "身份信息验证错误，请重新输入")
        return bank_card
      when 2  #银行卡信息错误
        bank_card.errors.add(:message, "银行卡授权失败，请重新输入银行卡信息")
        return bank_card
      end
    end

    bank_card_verify_info = BankCardVerifyInfo.create(name: params[:name], id_card: params[:id_card], bank_card: params[:card])
    
    # 调用接口
    result = bank_card.verify_bank_card_from_dq params
    if result["dq_code"] == "10000"
      bank_card.bankcard_no = params[:card]
      bank_card.id_card = params[:id_card]
      bank_card.name = params[:name]
      bank_card.card_type = params[:card_type]
      bank_card.customer_id = params[:customer_id]
      bank_card.stat_code = "00"
      bank_card.save

      # 添加个人信息
      customer = Customer.find_by_id(params[:customer_id])
      if customer.present? && customer.try(:customer_reg_info).try(:verify_state) == "unverified"
        PersonalInfo.find_or_create_by(name: params[:name], id_card: params[:id_card], result: 0)
        IdentityVerify.create(name: params[:name], id_card: params[:id_card], customer: customer)
        PensionAccount.create_by_phone customer.try(:user).phone
      end
      bank_card_verify_info.result = 0
      bank_card_verify_info.save!
    else
      # 调用实名制认证接口，查询身份证信息是否正确
      if (IdentityVerify.idcard_verify? params[:name], params[:id_card])
        bank_card.errors.add(:message, "银行卡授权失败，请重新输入银行卡信息")
        bank_card_verify_info.result = 2
      else
        bank_card.errors.add(:message, "身份信息验证错误，请重新输入")
        bank_card_verify_info.result = 1
      end
      bank_card_verify_info.save!
    end
    bank_card
  end

  def self.get_errors bank_name, bank_card_type
    if (bank_card_type.to_i == 0) || (BankCardType.bank_card_types[bank_card_type] == 0)
      "银行卡授权失败，所填银行卡号非#{bank_name}储蓄卡，请重新输入银行卡信息!"
    elsif (bank_card_type.to_i == 1) || (BankCardType.bank_card_types[bank_card_type] == 1)
      "银行卡授权失败，所填银行卡号非#{bank_name}信用卡，请重新输入银行卡信息!"
    end
  end

  def self.add_bank_card params
    # 需要四个参数, user_id, card, mobile, name
    bank_card = self.find_or_create_by(bankcard_no: params[:card], customer_id: params[:user_id])
    # if bank_card.res_code == "2004" # 银行卡正在绑定中，因此需要手动失败一次
    #   response = MultiJson.load RestClient.post("http://121.40.62.252:3000/auth/finish", params.to_json, content_type: :json, accept: :json)
    #   logger.info "bank card finish response is:#{response}"
    # end

    result = MultiJson.load RestClient.post("http://121.40.62.252:3000/auth/card", params.to_json, content_type: :json, accept: :json)

    # result = BankCard.new.verify_bank_card_from_xt params

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

      puts "bank card is:#{bank_card}"
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

    conn = Faraday.new(url: "#{xt_base_url}") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.post "#{xt_base_url}/uapi/verify/bankcard/v1?tranTime=#{tranTime}&tranDate=#{tranDate}&acctNo=#{acctNo}&acctName=#{acctName}&phone=#{phone}&certNo=#{certNo}&tranId=#{tranId}&merchId=#{merchId}&signature=#{signature}"

    result = MultiJson.load response.body
    p result

    result
  end

  def verify_bank_card_from_dq personal_info
    params = {
      api_name: "daqian.pay.verify_card",
      bp_id: "998800001145881",
      api_key: "real_7788000013635914866",
      bp_order_id: Time.zone.now.strftime("%Y%m%d%H%M%S"),
      user_name: personal_info[:name],
      cert_type: "a",
      cert_no: personal_info[:id_card],
      card_no: personal_info[:card],
      user_mobile: "" #personal_info[:phone] || ""
    }
    json_params = params.to_json
    signature = EncryptRsa.process(json_params, "key/dq/private_key4.pem").delete("\n")

    conn = Faraday.new(url: "#{dq_base_url}", ssl: { verify: false } )
    response = conn.post "#{dq_base_url}api/api.do", {data: json_params, sign: "#{signature}", sign_type: "RSA", version: "1.0"}
    result = MultiJson.load response.body
    data = URI::decode result["data"]
    hash_data = MultiJson.load data
    puts "daqian response result is: #{hash_data}"
    hash_data
  end

  def URLDecode(str)
    str.gsub!(/%[a-fA-F0-9]{2}/) { |x| x = x[1..2].hex.chr }
  end

  def self.add_bank_card_seed id, bank_name, debit_card, credit_card
    bank = Bank.find_or_create_by(id: id, name: bank_name)
    BankCardType.create(bank: bank, bank_name: bank_name, bank_card_type: 0) if debit_card
    BankCardType.create(bank: bank, bank_name: bank_name, bank_card_type: 1) if credit_card
  end

  private
    def dq_base_url
      "https://120.26.59.208:8443/"
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

    def update_bank_infomation
      #  bank_id            :integer
      #  bank_card_type     :integer
      bank = Bank.find_by_id(bank_id)
      unless bank.present?
        errors.add :bank, "该银行不存在"
        return false
      end

      bank.bank_card_amount += 1

      if bank_card_type == 0
        bank.debit_card_amount += 1
      elsif bank_card_type == 1
        bank.credit_card_amount += 1
      end

      bank.save!
    end

end
