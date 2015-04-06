# == Schema Information
#
# Table name: merchants
#
#  id               :integer          not null, primary key
#  merchant_user_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  ratio            :float
#

class Merchant < ActiveRecord::Base
  belongs_to :merchant_user 
  has_one :busi_reg_info, class_name: "MerchantBusiRegInfo", dependent: :destroy
  has_one :sys_reg_info, class_name: "MerchantSysRegInfo", dependent: :destroy
  has_many :shops
  has_many :member_cards
  has_many :tl_trades
  has_one :thumb, class_name: "Image", as: :imageable, dependent: :destroy
end
