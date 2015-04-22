# == Schema Information
#
# Table name: jajin_identity_codes
#
#  id              :integer          not null, primary key
#  identity_code   :string(255)
#  expiration_time :datetime
#  customer_id     :integer
#  merchant_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

RSpec.describe JajinIdentityCode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
