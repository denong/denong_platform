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

require 'rails_helper'

RSpec.describe BankCardVerifyInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
