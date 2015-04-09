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

class MerchantGivingLog < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
end
