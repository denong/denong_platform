# == Schema Information
#
# Table name: member_cards
#
#  id          :integer          not null, primary key
#  merchant_id :integer
#  point       :float            default(0.0)
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  user_name   :string(255)
#  passwd      :string(255)
#

class MemberCard < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer

  validates_uniqueness_of :user_name
end
