# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  pension    :float
#  jiajin     :float
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should belong_to :user }
  it { should have_one :customer_reg_info }
end
