# == Schema Information
#
# Table name: tl_trades
#
#  id          :integer          not null, primary key
#  phone       :string(255)
#  card        :string(255)
#  price       :float
#  trade_time  :datetime
#  pos_ind     :string(255)
#  shop_ind    :string(255)
#  trade_ind   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#  merchant_id :integer
#

require 'rails_helper'

RSpec.describe TlTrade, type: :model do
  it { should belong_to :customer }
  it { should belong_to :merchant }
  it { should have_one :jajin_log }
end