# == Schema Information
#
# Table name: jajin_logs
#
#  id             :integer          not null, primary key
#  amount         :float
#  jajinable_id   :integer
#  jajinable_type :string(255)
#  customer_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  merchant_id    :integer
#

require 'rails_helper'

RSpec.describe JajinLog, type: :model do
  it { should belong_to :jajinable }
  it { should belong_to :customer }
  it { should belong_to :merchant }
end
