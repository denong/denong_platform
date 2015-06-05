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

require 'rails_helper'

RSpec.describe ConsumeMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
