# == Schema Information
#
# Table name: member_cards
#
#  id                :integer          not null, primary key
#  merchant_id       :integer
#  point             :float(24)
#  customer_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  user_name         :string(255)
#  passwd            :string(255)
#  total_trans_jajin :float(24)        default(0.0)
#

require 'rails_helper'

RSpec.describe MemberCard, type: :model do
  it { should belong_to :merchant }
  it { should belong_to :customer }
end
