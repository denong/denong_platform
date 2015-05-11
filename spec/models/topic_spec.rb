# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  tags       :string(255)      default("--- []\n")
#

require 'rails_helper'

RSpec.describe Topic, type: :model do
  it { should have_many :merchants }
end
