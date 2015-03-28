# == Schema Information
#
# Table name: friendships
#
#  id          :integer          not null, primary key
#  userid      :integer
#  friendid    :integer
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { should belong_to :customer }
  
end
