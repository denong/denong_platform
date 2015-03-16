# == Schema Information
#
# Table name: tl_trades
#
#  id         :integer          not null, primary key
#  phone      :string(255)
#  card       :string(255)
#  price      :float
#  trade_time :datetime
#  pos_ind    :string(255)
#  shop_ind   :string(255)
#  trade_ind  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TlTrade < ActiveRecord::Base
end
