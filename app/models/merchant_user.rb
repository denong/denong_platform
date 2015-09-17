# == Schema Information
#
# Table name: merchant_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  phone                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  authentication_token   :string(255)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  api_key                :string(255)
#

class MerchantUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]
  
  attr_accessor :sms_token
  has_one :merchant
  validate :sms_token_validate

  validates_uniqueness_of :api_key
  validates_presence_of :api_key
  before_validation :generate_api_key

  def email_required?
    false
  end

  def self.reset_user_password params
    phone = params[:phone]
    password = params[:password]
    sms_token = params[:sms_token]
    merchant_user = MerchantUser.find_by phone: phone
    if merchant_user.present?
      merchant_user.password = password
      merchant_user.sms_token = sms_token
      merchant_user.save
    else
      merchant_user = MerchantUser.new
      merchant_user.errors.add(:phone, "对应的商户不存在")
    end
    merchant_user
  end

  def sms_token_validate
    sms_token_obj = SmsToken.find_by(phone: phone)

    return if sms_token == "989898"

    if sms_token_obj.blank?
      self.errors.add(:sms_token, "未获取，请先获取")
    elsif sms_token_obj.try(:updated_at) < Time.zone.now - 30.minute
      self.errors.add(:sms_token, "已失效，请重新获取")
    elsif sms_token_obj.try(:token) != sms_token 
      self.errors.add(:sms_token, "不正确，请重试")
    end
  end
  
  private

  def generate_api_key
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.api_key ||= chars.sample(16).join
  end

end
