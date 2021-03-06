# == Schema Information
#
# Table name: member_cards
#
#  id                :integer          not null, primary key
#  merchant_id       :integer
#  point             :float(24)
#  customer_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  user_name         :string(255)
#  passwd            :string(255)
#  total_trans_jajin :float(24)        default(0.0)
#

class MemberCard < ActiveRecord::Base
  # include ActionView::Helpers::AssetUrlHelper
  # 由于需求变动，passwd改成身份证号，user_name改成名字

  belongs_to :merchant
  belongs_to :customer

  has_many :member_card_point_logs

  validates_uniqueness_of :customer_id, scope: :merchant_id
  validate :authenticate, on: :create

  after_create :add_merchant_member_card_amount
  after_create :check_point

 scope :today, -> (datetime) { where('created_at between ? and ?', (datetime.to_date - 1.day).strftime("%Y-%m-%d 00:00:00"), datetime.to_date.strftime("%Y-%m-%d 00:00:00")) }
 scope :week, -> (datetime) { where('created_at between ? and ?', (datetime.to_date - 7.day).strftime("%Y-%m-%d 00:00:00"), datetime.to_date.strftime("%Y-%m-%d 00:00:00")) }
 scope :month, -> (datetime) { where('created_at between ? and ?', (datetime.to_date - 1.month).strftime("%Y-%m-%d 00:00:00"), datetime.to_date.strftime("%Y-%m-%d 00:00:00")) }

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
      if (passwd =~ /^(\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$/ && idcard_verify?)
        return true
      else
        errors.add(:message, "身份信息验证错误，请重新输入")
        return false
      end
    end

    def change_id_card id_card
      id_card = id_card.to_s
      unless id_card.size == 15
        return id_card 
      end
      
      id_card = id_card.insert(6,"19")
      sum = 0
      m_arr = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]
      (0..id_card.size-1).each do |index|
        sum += m_arr[index]*id_card[index].to_i
      end
      result = ["1","0","X","9","8","7","6","5","4","3","2"]
      id_card << result[sum%11]
      id_card
    end

    def idcard_verify?
      IdentityVerify.idcard_verify? user_name, passwd
    end

    # def old_authenticate
    #   #以后与其他商家对接,以下代码暂时用于内部测试
    #   member_card = MerchantCustomer.find_by(u_id: user_name)
    #   if member_card.nil?
    #     errors.add(:message, "会员卡不存在")
    #     return
    #   end

    #   if member_card.password != passwd
    #     puts "密码错误"
    #     errors.add(:message, "密码错误")
    #     return
    #   end
    #   self.point = member_card.jifen
    # end

    def add_merchant_member_card_amount
      merchant.member_card_amount += 1
      merchant.save
    end

    def check_point
      point = 0 if point.nil?
    end
end
