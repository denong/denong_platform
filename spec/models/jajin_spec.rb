# == Schema Information
#
# Table name: jajins
#
#  id          :integer          not null, primary key
#  got         :float
#  unverify    :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Jajin, type: :model do
  it { should belong_to :customer }
end
