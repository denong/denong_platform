# == Schema Information
#
# Table name: member_cards
#
#  id          :integer          not null, primary key
#  merchant_id :integer
#  point       :float            default(0.0)
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
  validate :authenticate, on: :create

  def merchant_logo
    merchant.try(:sys_reg_info).try(:logo) ? merchant.sys_reg_info.logo.photo.url(:product) : ""
  end

  def merchant_name
    merchant.try(:sys_reg_info).try(:sys_name)
  end

  def merchant_giving_jajin
    merchant.try(:get_giving_jajin)
  end

  private
  
    def authenticate
      #以后与其他商家对接,以下代码暂时用于内部测试
      member_card = MerchantCustomer.find_by(u_id: user_name)
      if member_card.nil?
        puts "会员卡不存在"
        errors.add(:message, "会员卡不存在")
        return
      end

      if member_card.password != passwd
        puts "密码错误"
        errors.add(:message, "密码错误")
        return
      end
      self.point = member_card.jifen
    end



end
