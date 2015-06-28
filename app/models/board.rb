# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  pic_url    :string(255)
#

class Board < ActiveRecord::Base
  has_one :pic, class_name: "Image", as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :pic, allow_destroy: true

  def picture_url
    local_pic = image_url(pic.photo.url(:product)) if pic
    pic_url.present? ? pic_url : local_pic.to_s
  end
  
end
