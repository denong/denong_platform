# == Schema Information
#
# Table name: tickets
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { should belong_to :customer}
end
