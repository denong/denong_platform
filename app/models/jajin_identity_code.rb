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

  validates_uniqueness_of :identity_code
  validates_presence_of :identity_code

  def self.add_identity_code init_data
    identity_code = (0...20).map { ('a'..'z').to_a[rand(26)] }.join
    init_data[:identity_code] = identity_code
    self.create init_data
  end

end
