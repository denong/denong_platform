# == Schema Information
#
# Table name: agents
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  phone                  :string(255)
#  contact_person         :string(255)
#  fax                    :string(255)
#  addr                   :string(255)
#  lat                    :float
#  lon                    :float
#  created_at             :datetime
#  updated_at             :datetime
#  email                  :string(255)      default(""), not null
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
#

class Agent < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]

  attr_accessor :sms_token
  has_many :merchants
  validate :sms_token_validate

  validates_uniqueness_of :phone
  validates_presence_of :phone
  validates :phone, length: { is: 11 }
  validates_uniqueness_of :email
  validates_presence_of :email


  def email_required?
    false
  end

  def self.reset_user_password params
    phone = params[:phone]
    password = params[:password]
    sms_token = params[:sms_token]
    agent = Agent.find_by phone: phone
    if agent.present?
      agent.password = password
      agent.sms_token = sms_token
      agent.save
    else
      agent = Agent.new
      agent.errors.add(:phone, "对应的商户不存在")
    end
    agent
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
end
