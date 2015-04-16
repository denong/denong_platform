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

class IdentityVerify < ActiveRecord::Base
  enum verify_state: [ :unverified, :wait_verify, :verified]
  belongs_to :customer
  has_one :front_image, -> { where photo_type: "front" }, class_name: "Image", as: :imageable, dependent: :destroy
  has_one :back_image, -> { where photo_type: "back" }, class_name: "Image", as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :front_image, allow_destroy: true
  accepts_nested_attributes_for :back_image, allow_destroy: true

  before_save :set_state

  validates :name, presence: true
  validates :id_card, presence: true
  validates :front_image, presence: true
  validates :back_image, presence: true

  def set_state
    self.verify_state = :unverified
  end
  
end
