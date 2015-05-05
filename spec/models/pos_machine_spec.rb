# == Schema Information
#
# Table name: pos_machines
#
#  id             :integer          not null, primary key
#  acquiring_bank :integer
#  operator       :string(255)
#  opertion_time  :datetime
#  shop_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  pos_ind        :string(255)
#

require 'rails_helper'

RSpec.describe PosMachine, type: :model do
  it { should belong_to :shop} 
end
