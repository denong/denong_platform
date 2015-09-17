# == Schema Information
#
# Table name: merchant_sys_reg_infos
#
#  id             :integer          not null, primary key
#  sys_name       :string(255)
#  contact_person :string(255)
#  contact_tel    :string(255)
#  service_tel    :string(255)
#  fax_tel        :string(255)
#  email          :string(255)
#  company_addr   :string(255)
#  region         :string(255)
#  industry       :string(255)
#  postcode       :string(255)
#  reg_time       :datetime
#  approve_time   :datetime
#  lon            :float(24)        default(0.0)
#  lat            :float(24)        default(0.0)
#  welcome_string :string(255)
#  comment_text   :text
#  created_at     :datetime
#  updated_at     :datetime
#  merchant_id    :integer
#

require 'rails_helper'

RSpec.describe MerchantSysRegInfo, type: :model do
  it { should belong_to(:merchant).touch(true) }
end
