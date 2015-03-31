# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  belongs_to :user
  has_one :customer_reg_info, dependent: :destroy
  has_many :member_cards, dependent: :destroy
  has_one :jajin, dependent: :destroy
  has_one :pension, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, dependent: :destroy
  has_many :jajin_logs, dependent: :destroy

  def add_friend! customer
    self.friendships.find_or_create_by!(friend_id: customer.id)
  end

  def has_friend? customer
    self.friendships.find_by_friend_id(customer).present?
  end

  def remove_friend! customer
    self.friendships.find_by_friend_id(customer).try(:destroy)
  end
end
