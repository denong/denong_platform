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
#  consumption :float
#

class MerchantGivingLog < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  has_one :jajin_log, as: :jajinable

end
