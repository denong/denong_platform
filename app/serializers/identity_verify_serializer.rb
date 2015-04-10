# == Schema Information
#
# Table name: identity_verifies
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  verify_state :integer
#  customer_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#  id_card      :string(255)
#

class IdentityVerifySerializer < ActiveModel::Serializer
  attributes :id
end
