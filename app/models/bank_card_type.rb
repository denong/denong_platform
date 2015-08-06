# == Schema Information
#
# Table name: bank_card_types
#
#  id             :integer          not null, primary key
#  bank_name      :string(255)
#  bank_card_type :integer
#  created_at     :datetime
#  updated_at     :datetime
#  bank_id        :integer
#

class BankCardType < ActiveRecord::Base
  # debit_card: 借记卡, credit_card: 信用卡
  enum bank_card_type: { debit_card: 0, credit_card: 1}

  belongs_to :bank
  
  searchable do  
    integer :bank_card_type_id
    text :bank_name 
  end 

  def bank_card_type_id
    BankCardType.bank_card_types[self.bank_card_type]
  end
end
