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

  before_create :check_customer

  def self.add_bank_card params
    result = MultiJson.load RestClient.post("http://121.40.62.252/auth/card")
    if result.present? && result["result"].present?
      self.create( name: @params["name"], bankcard_no: @params["card"], phone: @params["phone"], customer: customer)
    end
  end

  def self.send_msg params
    @params = params
    # result = RestClient.post 'http://192.168.2.100:8080/auth/card', @params
  end

  private
    def check_customer
      user = User.find_or_create_by phone:phone do |user|
        user.sms_token = "989898"
        user.password = "12345678"
      end
      self.customer = user.customer
    end
end
