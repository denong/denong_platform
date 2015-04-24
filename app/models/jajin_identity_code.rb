# == Schema Information
#
# Table name: jajin_identity_codes
#
#  id              :integer          not null, primary key
#  expiration_time :datetime
#  merchant_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  amount          :float
#  verify_code     :string(255)
#  verify_state    :integer          default(0)
#

class JajinIdentityCode < ActiveRecord::Base
  enum verify_state: { unverified: 0, verified: 1 }

  belongs_to :customer
  belongs_to :merchant

  validates_uniqueness_of :verify_code
  validates_presence_of :verify_code

  validates_presence_of :amount

  before_validation :generate_verify_code

  def self.activate_by_verify_code verify_code
    identity = find_by verify_code: verify_code
    if identity.present? && identity.unverified?
      identity.verified!
      return true
    end
    return false
  end

  private
    def generate_verify_code
      self.verify_code ||= Devise.friendly_token.first(10)
    end

end
