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
#  amount      :float(24)
#  comment     :string(255)
#

class RewardLogSerializer < ActiveModel::Serializer
  attributes :id, :amount, :float, :verify_code, :verify_time
  has_one :reward
  has_one :customer
  has_one :merchant
end
