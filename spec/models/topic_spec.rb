# == Schema Information
#
# Table name: topics
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  subtitle                :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  tags                    :string(255)      default("--- []\n")
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float(24)        default(0.0)
#

require 'rails_helper'

RSpec.describe Topic, type: :model do
  it { should have_many :merchants }
end
