# == Schema Information
#
# Table name: balance_logs
#
#  id          :integer          not null, primary key
#  jajin       :float
#  balance     :float
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe BalanceLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
