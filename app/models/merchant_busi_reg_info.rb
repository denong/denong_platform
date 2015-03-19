# == Schema Information
#
# Table name: merchant_busi_reg_infos
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  addr          :string(255)
#  legal         :string(255)
#  id_card       :string(255)
#  licence       :string(255)
#  organize_code :string(255)
#  tax_code      :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  merchant_id   :integer
#

class MerchantBusiRegInfo < ActiveRecord::Base
  belongs_to :merchant
end
