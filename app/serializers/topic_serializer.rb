# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  tags       :text             default("--- []\n")
#

class TopicSerializer < ActiveModel::Serializer
  attributes :id
end
