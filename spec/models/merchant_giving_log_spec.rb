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
#

require 'rails_helper'

RSpec.describe MerchantGivingLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
