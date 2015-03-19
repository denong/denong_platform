# == Schema Information
#
# Table name: merchant_sys_reg_infos
#
#  id               :integer          not null, primary key
#  sys_name         :string(255)
#  contact_person   :string(255)
#  contact_tel      :string(255)      default("--- []\n")
#  service_tel      :string(255)      default("--- []\n")
#  fax_tel          :string(255)      default("--- []\n")
#  email            :string(255)
#  company_addr     :string(255)
#  region           :string(255)
#  industry         :string(255)
#  postcode         :string(255)
#  reg_time         :datetime
#  approve_time     :datetime
#  lon              :float
#  lat              :float
#  welcome_string   :string(255)
#  comment_text     :text
#  merchant_user_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

RSpec.describe MerchantSysRegInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
