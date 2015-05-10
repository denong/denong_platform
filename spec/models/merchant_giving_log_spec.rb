# == Schema Information
#
# Table name: merchant_giving_logs
#
#  id          :integer          not null, primary key
#  amount      :float
#  giving_time :datetime
#  merchant_id :integer
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  shop_id     :integer
#

require 'rails_helper'

RSpec.describe MerchantGivingLog, type: :model do
  it { should belong_to :customer }
  it { should belong_to :merchant }
  it { should have_one :jajin_log }
end
