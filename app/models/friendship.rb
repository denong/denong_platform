# == Schema Information
#
# Table name: friendships
#
#  id          :integer          not null, primary key
#  friend_id   :integer
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Friendship < ActiveRecord::Base
  belongs_to :customer
  belongs_to :friend, class_name: "Customer", foreign_key: "friend_id"
end
