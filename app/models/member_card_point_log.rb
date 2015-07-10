# == Schema Information
#
# Table name: member_card_point_logs
#
#  id          :integer          not null, primary key
#  member_card :string(255)
#  point       :float
#  jajin       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class MemberCardPointLog < ActiveRecord::Base
  belongs_to :customer
end
