# == Schema Information
#
# Table name: reward_logs
#
#  id          :integer          not null, primary key
#  reward_id   :integer
#  customer_id :integer
#  merchant_id :integer
#  amount      :string(255)
#  float       :string(255)
#  verify_code :string(255)
#  verify_time :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class RewardLog < ActiveRecord::Base
  belongs_to :reward
  belongs_to :customer
  belongs_to :merchant
end
