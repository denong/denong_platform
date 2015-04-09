# == Schema Information
#
# Table name: gain_histories
#
#  id          :integer          not null, primary key
#  gain        :float
#  gain_date   :datetime
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe GainHistory, type: :model do
  it { should belong_to :customer }
end
