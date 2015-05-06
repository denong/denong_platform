# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  Title      :string(255)
#  Subtitle   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Topic, type: :model do
  it { should have_many :merchants }
end
