# == Schema Information
#
# Table name: consume_messages
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  trade_time  :datetime
#  amount      :float
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#  company     :string(255)
#

class ConsumeMessageSerializer < ActiveModel::Serializer
  attributes :id
end
