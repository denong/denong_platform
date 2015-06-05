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
#

class ConsumeMessage < ActiveRecord::Base
  belongs_to :merchant

  default_scope { order('id DESC') }
end
