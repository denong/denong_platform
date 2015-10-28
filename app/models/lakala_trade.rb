# == Schema Information
#
# Table name: lakala_trades
#
#  id             :integer          not null, primary key
#  phone          :string(255)
#  card           :string(255)
#  price          :float(24)
#  pos_ind        :string(255)
#  shop_ind       :string(255)
#  trade_ind      :string(255)
#  trade_time     :string(255)
#  pos_machine_id :integer
#  shop_id        :integer
#  customer_id    :integer
#  merchant_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class LakalaTrade < ActiveRecord::Base
  belongs_to :pos_machine
  belongs_to :shop
  belongs_to :customer
  belongs_to :merchant
end
