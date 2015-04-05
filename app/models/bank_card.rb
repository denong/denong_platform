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
#

class BankCard < ActiveRecord::Base
  belongs_to :customer

  before_create :check_customer
  after_create :show_data
  private

    def check_customer
      user = User.find_by_phone(phone)
      if user.nil?
        user = User.create! phone: phone, sms_token: "989898", password: "12345678"
      end

      finded_card = BankCard.find_by_bankcard_no(bankcard_no)
      unless user.customer.bank_cards.include? (finded_card) 
        self.customer = user.customer
      end
    end

    #当这张卡已经创建时，则如何返回该卡？
    def show_data
      # puts "customer_id is #{customer_id}"
    end

end
