# == Schema Information
#
# Table name: given_logs
#
#  id                :integer          not null, primary key
#  giver_or_given_id :integer
#  amount            :float
#  created_at        :datetime
#  updated_at        :datetime
#  customer_id       :integer
#

require 'rails_helper'

RSpec.describe GivenLog, type: :model do
  it { should have_one :jajin_log }
end
