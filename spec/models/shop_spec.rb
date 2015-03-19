# == Schema Information
#
# Table name: shops
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  addr           :string(255)
#  contact_person :string(255)
#  contact_tel    :string(255)
#  work_time      :string(255)
#  merchant_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'rails_helper'

RSpec.describe Shop, type: :model do
  it { should belong_to  :merchant} 
  it { should have_many :pos_machines }
end
