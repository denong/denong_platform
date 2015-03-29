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
  has_one :customer_reg_info
  has_many :member_cards
  has_one :jajin
  has_one :pension
  has_many :friendships
  has_many :friends, through: :friendships, dependent: :destroy

  def add_friend! customer
    self.friendships.find_or_create_by!(friend_id: customer.id)
  end

  def has_friend? customer
    self.friendships.find_by(friend_id: customer.id).nil? == false
  end

  def remove_friend! customer
    friend = self.friendships.find_by(friend_id: customer.id)
    if friend
      friend.destroy!
    end
  end
end
