# == Schema Information
#
# Table name: reward_logs
#
#  id          :integer          not null, primary key
#  reward_id   :integer
#  customer_id :integer
#  merchant_id :integer
#  verify_code :string(255)
#  verify_time :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  amount      :float
#

require 'rails_helper'

RSpec.describe RewardLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
