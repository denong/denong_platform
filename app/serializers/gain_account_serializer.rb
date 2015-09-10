# == Schema Information
#
# Table name: gain_accounts
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  gain_org_id :integer
#  total       :float(24)
#  created_at  :datetime
#  updated_at  :datetime
#

class GainAccountSerializer < ActiveModel::Serializer
  attributes :id
end
