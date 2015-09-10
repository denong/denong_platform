# == Schema Information
#
# Table name: jajins
#
#  id          :integer          not null, primary key
#  got         :float(24)
#  unverify    :float(24)
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Jajin, type: :model do
  it { should belong_to :customer }
end
