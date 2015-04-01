# == Schema Information
#
# Table name: exchange_logs
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#

class ExchangeLog < ActiveRecord::Base
  belongs_to :customer
  has_one :jajin_log, as: :jajinable
end
