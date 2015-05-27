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
#  user_name   :string(255)
#  Passwd      :string(255)
#

require 'rails_helper'

RSpec.describe MemberCard, type: :model do
  it { should belong_to :merchant }
  it { should belong_to :customer }
end
