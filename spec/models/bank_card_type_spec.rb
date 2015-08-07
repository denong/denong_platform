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

require 'rails_helper'

RSpec.describe BankCardType, type: :model do
end
