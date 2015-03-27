# == Schema Information
#
# Table name: customer_reg_infos
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  name        :string(255)
#  idcard      :string(255)
#  audit_state :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe CustomerRegInfo, type: :model do
  it { should belong_to :customer }
end
