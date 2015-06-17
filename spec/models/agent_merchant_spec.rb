# == Schema Information
#
# Table name: agent_merchants
#
#  id          :integer          not null, primary key
#  agent_id    :integer
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe AgentMerchant, type: :model do
end
