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

class AgentMerchant < ActiveRecord::Base
  belongs_to :agent
  belongs_to :merchant
end
