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

class IdentityVerify < ActiveRecord::Base
  enum verify_state: [ :unverified, :wait_verify, :verified]
  belongs_to :customer

  before_save :set_state

  def set_state
    self.verify_state = :unverified
  end
  
end
