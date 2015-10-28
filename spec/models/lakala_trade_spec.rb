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

require 'rails_helper'

RSpec.describe LakalaTrade, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
