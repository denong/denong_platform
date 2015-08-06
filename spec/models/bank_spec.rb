# == Schema Information
#
# Table name: banks
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  bank_card_amount   :integer          default(0)
#  debit_card_amount  :integer          default(0)
#  credit_card_amount :integer          default(0)
#

require 'rails_helper'

RSpec.describe Bank, type: :model do
  it { should have_searchable_field :name }
end
