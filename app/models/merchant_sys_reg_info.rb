# == Schema Information
#
# Table name: merchant_sys_reg_infos
#
#  id             :integer          not null, primary key
#  sys_name       :string(255)
#  contact_person :string(255)
#  contact_tel    :string(255)      default("--- []\n")
#  service_tel    :string(255)      default("--- []\n")
#  fax_tel        :string(255)      default("--- []\n")
#  email          :string(255)
#  company_addr   :string(255)
#  region         :string(255)
#  industry       :string(255)
#  postcode       :string(255)
#  reg_time       :datetime
#  approve_time   :datetime
#  lon            :float
#  lat            :float
#  welcome_string :string(255)
#  comment_text   :text
#  created_at     :datetime
#  updated_at     :datetime
#  merchant_id    :integer
#

class MerchantSysRegInfo < ActiveRecord::Base
  belongs_to :merchant, touch: true
  has_one :image, -> { where photo_type: "image" }, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, allow_destroy: true

  has_one :logo, -> { where photo_type: "logo" }, class_name: "Image", as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :logo, allow_destroy: true

end
