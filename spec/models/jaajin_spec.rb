# == Schema Information
#
# Table name: jaajins
#
#  id          :integer          not null, primary key
#  got         :float
#  unverify    :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Jaajin, type: :model do
  it { should belong_to :customer }
end
