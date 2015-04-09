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
  has_one :jajin_log, as: :jajinable
  
  def as_json(options=nil)
    {
      id: id,
      amount: amount,
      giving_time: giving_time,
      merchant_id: merchant_id,
      customer_id: customer_id,
      created_at: created_at,
      updated_at: updated_at,
      given: ""
    }
  end

end
