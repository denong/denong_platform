# == Schema Information
#
# Table name: gain_accounts
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  gain_org_id :integer
#  total       :float
#  created_at  :datetime
#  updated_at  :datetime
#

class GainAccount < ActiveRecord::Base
  belongs_to :customer
  belongs_to :gain_org
end
