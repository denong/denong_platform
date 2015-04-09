# == Schema Information
#
# Table name: yl_trades
#
#  id             :integer          not null, primary key
#  trade_time     :datetime
#  log_time       :date
#  trade_currency :string(255)
#  trade_state    :string(255)
#  gain           :float
#  expend         :float
#  merchant_ind   :string(255)
#  pos_ind        :string(255)
#  merchant_name  :string(255)
#  merchant_type  :string(255)
#  merchant_city  :string(255)
#  trade_type     :string(255)
#  trade_way      :string(255)
#  merchant_addr  :string(255)
#  customer_id    :integer
#  merchant_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class YlTrade < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
  has_one :jajin_log, as: :jajinable
end
