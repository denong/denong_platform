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

require 'rails_helper'

RSpec.describe IdentityVerify, type: :model do
  it { should belong_to :customer }
end
