# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :content
end
