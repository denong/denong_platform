# == Schema Information
#
# Table name: pensions
#
#  id          :integer          not null, primary key
#  account_id  :integer
#  total       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Pension, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
