# == Schema Information
#
# Table name: bank_cards
#
#  id          :integer          not null, primary key
#  bankcard_no :string(255)
#  id_card     :string(255)
#  name        :string(255)
#  phone       :string(255)
#  card_type   :integer
#  sn          :string(255)
#  bank        :integer
#  bind_state  :integer
#  bind_time   :datetime
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  res_msg     :string(255)
#  stat_desc   :string(255)
#

class BankCard < ActiveRecord::Base
  belongs_to :customer

  validates_uniqueness_of :bankcard_no, scope: :phone

  def self.add_bank_card params
    # 需要四个参数, user_id, card, mobile, name
    result = MultiJson.load RestClient.post("http://121.40.62.252:3000/auth/card", params.to_json, content_type: :json, accept: :json)
    if result.present? && result["result"].present?
      bank_card = self.find_or_create_by(bankcard_no: params[:card], phone: params[:mobile], customer_id: params[:user_id]) do |bank_card|
        bank_card.name = params[:name]
        if bank_card.stat_desc != "认证成功" || bank_card.stat_desc != "认证申请成功"
          bank_card.res_msg = result["result"]["resMsg"] if result["result"]["resMsg"]
          bank_card.stat_desc = result["result"]["statDesc"] if result["result"]["statDesc"]
        end
      end
      bank_card
    else
      nil
    end
  end

  def self.send_msg params
    # 需要三个参数, user_id, card, answer
    result = MultiJson.load RestClient.post('http://121.40.62.252:3000/auth/answer', params.to_json, content_type: :json, accept: :json)
 
    bank_card = self.find_by bankcard_no: params[:card], customer_id: params[:user_id]
    if bank_card.present? && result.present? && result["result"].present?
      bank_card.stat_desc = result["result"]["statDesc"] if result["result"]["statDesc"]
      bank_card.save
    end
    bank_card
  end

  def self.find_info bank_card_number
    @bank_card_info = find_info_by_place(bank_card_number, 5) || find_info_by_place(bank_card_number, 4) || find_info_by_place(bank_card_number, 3)
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
