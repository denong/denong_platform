# == Schema Information
#
# Table name: member_cards
#
#  id                :integer          not null, primary key
#  merchant_id       :integer
#  point             :float            default(0.0)
#  customer_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#  user_name         :string(255)
#  passwd            :string(255)
#  total_trans_jajin :float            default(0.0)
#

class MemberCard < ActiveRecord::Base
  # include ActionView::Helpers::AssetUrlHelper
  # 由于需求变动，passwd改成身份证号，user_name改成名字

  belongs_to :merchant
  belongs_to :customer

  has_many :member_card_point_logs

  validates_uniqueness_of :passwd, scope: :merchant_id
  validate :authenticate, on: :create

  after_create :add_merchant_member_card_amount
  after_create :check_point

  scope :today, -> { where('created_at > ?', Time.zone.now.to_date - 1.day) }
  scope :week, -> { where('created_at > ?', Time.zone.now.to_date - 7.day ) }
  scope :month, -> { where('created_at > ?', Time.zone.now.to_date - 30.day ) }

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

    def idcard_verify?
      personal_info = PersonalInfo.find_by_id_card(passwd)
      if personal_info.present? && personal_info.name == user_name
        return true
      end
      response = RestClient.get 'http://apis.haoservice.com/idcard/VerifyIdcard', {params: {cardNo: passwd, realName: user_name, key: "0e7253b6cf7f46088c18a11fdf42fd1b"}}
      response_hash = MultiJson.load(response)
      if response_hash["error_code"].to_i == 0
        if response_hash["result"]["isok"]
          PersonalInfo.find_or_create_by(name: user_name, id_card: passwd)
        end
        response_hash["result"]["isok"]
      else
        false
      end
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
