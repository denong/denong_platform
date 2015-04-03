# == Schema Information
#
# Table name: merchants
#
#  id               :integer          not null, primary key
#  merchant_user_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  ratio            :float
#

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should belong_to :merchant_user }
  it { should have_one :busi_reg_info }
  it { should have_one :sys_reg_info }
  it { should have_many :shops}
  it { should have_many :tl_trades }
end
