# == Schema Information
#
# Table name: merchant_messages
#
#  id          :integer          not null, primary key
#  time        :datetime
#  title       :string(255)
#  content     :string(255)
#  summary     :string(255)
#  url         :string(255)
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#

class MerchantMessage < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  has_one :thumb, class_name: "Image", as: :imageable, dependent: :destroy


end