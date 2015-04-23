# == Schema Information
#
# Table name: jajin_verify_logs
#
#  id          :integer          not null, primary key
#  amount      :float
#  verify_code :string(255)
#  verify_time :datetime
#  customer_id :integer
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe JajinVerifyLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
