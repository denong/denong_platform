# == Schema Information
#
# Table name: pension_logs
#
#  id           :integer          not null, primary key
#  customer_id  :integer
#  jajin_amount :float
#  amount       :float
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

RSpec.describe PensionLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
