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

require 'rails_helper'

RSpec.describe BankCardType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
