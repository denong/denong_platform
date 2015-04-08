# == Schema Information
#
# Table name: customer_reg_infos
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  name        :string(255)
#  idcard      :string(255)
#  audit_state :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class CustomerRegInfo < ActiveRecord::Base
  enum audit_state: [ :unverified, :wait_verify, :verified]
  belongs_to :customer
  has_one :image, as: :imageable, dependent: :destroy
end
