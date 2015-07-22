# == Schema Information
#
# Table name: pensions
#
#  id          :integer          not null, primary key
#  total       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  account     :string(255)
#  state       :integer          default(0)
#  id_card     :string(255)
#

require 'rails_helper'

RSpec.describe Pension, type: :model do
  it { should belong_to :customer }
end
