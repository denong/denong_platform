# == Schema Information
#
# Table name: pensions
#
#  id          :integer          not null, primary key
#  total       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  account     :integer
#

require 'rails_helper'

RSpec.describe Pension, type: :model do
  it { should belong_to :customer }
end
