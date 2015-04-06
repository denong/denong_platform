# == Schema Information
#
# Table name: identity_verifies
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  id_num       :string(255)
#  verify_state :integer
#  customer_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class IdentityVerifySerializer < ActiveModel::Serializer
  attributes :id
end
