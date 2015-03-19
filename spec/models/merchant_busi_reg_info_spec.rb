# == Schema Information
#
# Table name: merchant_busi_reg_infos
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  addr             :string(255)
#  legal            :string(255)
#  id_card          :string(255)
#  licence          :string(255)
#  organize_code    :string(255)
#  tax_code         :string(255)
#  merchant_user_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

RSpec.describe MerchantBusiRegInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
