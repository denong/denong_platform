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

require 'rails_helper'

RSpec.describe MemberCardPointLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
