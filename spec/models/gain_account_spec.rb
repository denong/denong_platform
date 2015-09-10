# == Schema Information
#
# Table name: gain_accounts
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  gain_org_id :integer
#  total       :float(24)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe GainAccount, type: :model do
  it { should belong_to :customer }
  it { should belong_to :gain_org }
end
