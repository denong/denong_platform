# == Schema Information
#
# Table name: shops
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  addr                    :string(255)
#  contact_person          :string(255)
#  contact_tel             :string(255)
#  work_time               :string(255)
#  merchant_id             :integer
#  created_at              :datetime
#  updated_at              :datetime
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#

require 'rails_helper'

RSpec.describe Shop, type: :model do
  it { should belong_to  :merchant} 
  it { should have_many :pos_machines }
end
