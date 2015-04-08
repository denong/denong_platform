# == Schema Information
#
# Table name: member_cards
#
#  id          :integer          not null, primary key
#  merchant_id :integer
#  point       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class MemberCard < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer

  
end
