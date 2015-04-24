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
#

class JajinIdentityCode < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant

  validates_uniqueness_of :verify_code
  validates_presence_of :verify_code

  validates_presence_of :amount

  before_create :generate_identity_code

  private
    def generate_identity_code
      self.verify_code = Devise.friendly_token.first(10)
    end

end
