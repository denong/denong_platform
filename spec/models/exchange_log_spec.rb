# == Schema Information
#
# Table name: exchange_logs
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe ExchangeLog, type: :model do
  it { should belong_to :customer }
  it { should have_one :jajin_log }
end
