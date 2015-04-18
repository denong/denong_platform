# == Schema Information
#
# Table name: customer_reg_infos
#
#  id           :integer          not null, primary key
#  customer_id  :integer
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  verify_state :integer
#  id_card      :string(255)
#  nick_name    :string(255)
#  gender       :integer
#  phone        :string(255)
#

class CustomerRegInfo < ActiveRecord::Base
  enum verify_state: [:unverified, :wait_verify, :verified]
  enum gender: [:male, :female]
  belongs_to :customer
  has_one :image, as: :imageable, dependent: :destroy
end
