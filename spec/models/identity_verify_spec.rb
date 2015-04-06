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

require 'rails_helper'

RSpec.describe IdentityVerify, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
