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

class JajinIdentityCode < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
end
