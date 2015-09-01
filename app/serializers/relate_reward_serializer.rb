# == Schema Information
#
# Table name: relate_rewards
#
#  id          :integer          not null, primary key
#  phone       :string(255)
#  verify_code :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class RelateRewardSerializer < ActiveModel::Serializer
  attributes :id
end
