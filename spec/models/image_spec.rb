# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  photo_type         :string(255)
#  imageable_id       :integer
#  imageable_type     :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

require 'rails_helper'

RSpec.describe Image, type: :model do
end
