# == Schema Information
#
# Table name: bank_card_types
#
#  id             :integer          not null, primary key
#  bank_name      :string(255)
#  bank_card_type :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class BankCardType < ActiveRecord::Base
  # debit_card: 借记卡, credit_card: 信用卡
  enum bank_card_type: [ :debit_card, :credit_card]

  searchable do  
    text :bank_name 
  end 
end
