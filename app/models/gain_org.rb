# == Schema Information
#
# Table name: gain_orgs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  sub_title  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class GainOrg < ActiveRecord::Base
  has_one :thumb, class_name: "Image", as: :imageable, dependent: :destroy
end
