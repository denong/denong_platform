# == Schema Information
#
# Table name: customer_reg_infos
#
#  id           :integer          not null, primary key
#  customer_id  :integer
#  name         :string(255)
#  idcard       :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  verify_state :integer
#

class CustomerRegInfo < ActiveRecord::Base
  enum verify_state: [ :unverified, :wait_verify, :verified]
  belongs_to :customer
  has_one :image, as: :imageable, dependent: :destroy
end
