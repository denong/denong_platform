# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Topic < ActiveRecord::Base
  has_many :merchants, dependent: :destroy
  has_one :thumb, class_name: "Image", as: :imageable, dependent: :destroy

  acts_as_taggable
  acts_as_taggable_on :merchants
end
