# == Schema Information
#
# Table name: balance_logs
#
#  id          :integer          not null, primary key
#  jajin       :float(24)
#  balance     :float(24)
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe BalanceLog, type: :model do
end
