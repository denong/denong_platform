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

  def self.add_identity_code init_data
    verify_code = Time.now.to_i.to_s + (0...20).map { ('a'..'z').to_a[rand(26)] }.join
    init_data[:verify_code] = verify_code
    self.create init_data
  end

end
