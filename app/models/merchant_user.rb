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
end
