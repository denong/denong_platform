# == Schema Information
#
# Table name: member_card_point_logs
#
#  id             :integer          not null, primary key
#  point          :float(24)
#  jajin          :float(24)
#  customer_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  member_card_id :integer
#  unique_ind     :string(255)
#

require 'rails_helper'

RSpec.describe MemberCardPointLog, type: :model do
end
