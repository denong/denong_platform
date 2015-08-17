# == Schema Information
#
# Table name: bank_card_verify_infos
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  id_card    :string(255)
#  bank_card  :string(255)
#  result     :integer
#  created_at :datetime
#  updated_at :datetime
#

class BankCardVerifyInfo < ActiveRecord::Base

  enum verify_result: { success: 0, identity_error: 1, bank_error: 2}

end
