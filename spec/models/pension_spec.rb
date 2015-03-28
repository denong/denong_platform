# == Schema Information
#
# Table name: pensions
#
#  id          :integer          not null, primary key
#  account     :integer
#  total       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Pension, type: :model do
  it { should belong_to :customer }
end
