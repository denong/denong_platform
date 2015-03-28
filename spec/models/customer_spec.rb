# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should belong_to :user }
  it { should have_one :customer_reg_info }
  it { should have_one :jaajin}
  it { should have_one :pension }
  it { should have_many :member_cards }
  it { should have_many :friendships }
  # it { should have_many :friends }
end
