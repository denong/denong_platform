# == Schema Information
#
# Table name: member_cards
#
#  id          :integer          not null, primary key
#  merchant_id :integer
#  point       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  user_name   :string(255)
#  passwd      :string(255)
#

class MemberCard < ActiveRecord::Base
  # include ActionView::Helpers::AssetUrlHelper
  
  belongs_to :merchant
  belongs_to :customer

  validates_uniqueness_of :user_name, scope: :merchant_id

  def merchant_logo
    merchant.try(:sys_reg_info).try(:logo) ? merchant.sys_reg_info.image.photo.url(:product) : ""
  end

  def merchant_name
    merchant.try(:sys_reg_info).try(:sys_name)
  end

  def merchant_giving_jajin
    merchant.try(:get_giving_jajin)
  end

end
