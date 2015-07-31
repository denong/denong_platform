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

  private
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
