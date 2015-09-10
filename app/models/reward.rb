# == Schema Information
#
# Table name: rewards
#
#  id          :integer          not null, primary key
#  amount      :float(24)
#  verify_code :string(255)
#  max         :integer
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  comment     :string(255)
#

class Reward < ActiveRecord::Base
  belongs_to :merchant

  validates_uniqueness_of :verify_code
  validates_presence_of :verify_code
  validates_presence_of :amount

  before_validation :generate_verify_code

  def activate_by_customer customer
    
  end

  def self.verify?(verify_code)
    Reward.where(verify_code: verify_code).first.present?
  end

  private
    def generate_verify_code
      # self.verify_code ||= Devise.friendly_token.first(10)
      # self.verify_code ||= (0..9).to_a.sample(8).join
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      self.verify_code ||= chars.sample(8).join
    end

end
