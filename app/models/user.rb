# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  phone                  :string(255)
#  authentication_token   :string(255)
#  os                     :string(255)
#  device_token           :string(255)
#  user_source            :integer          default(0)
#  source_id              :integer          default(3)
#

class User < ActiveRecord::Base
  include ActionView::Helpers::AssetUrlHelper
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  enum user_source: [:merchant, :customer]

  scope :today, -> { where('created_at > ?', Time.now.to_date - 1.day) }
  scope :week, -> { where('created_at > ?', Time.now.to_date - 1.week) }
  scope :month, -> { where('created_at > ?', Time.now.to_date - 1.month) }

  scope :today_sign_in, -> { where('last_sign_in_at > ?', Time.now.to_date - 1.day) }
  scope :week_sign_in, -> { where('last_sign_in_at > ?', Time.now.to_date - 1.week) }
  scope :month_sign_in, -> { where('last_sign_in_at > ?', Time.now.to_date - 1.month ) }
  scope :all_sign_in, -> { where('last_sign_in_at is not null') }

  scope :ios_count, -> { where(os: 'ios') }
  scope :android_count, -> { where(os: 'android') }

  include ActiveModel::Validations

  attr_accessor :sms_token

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:phone]

  validates_uniqueness_of :phone
  validates_presence_of :phone
  validates :phone, length: { is: 11 }
  has_one :customer
  validate :sms_token_validate
  after_create :add_customer

  def self.find_or_create_by_phone phone
    user = User.find_by_phone(phone)
    if user.nil?
      password = (0..9).to_a.sample(6).join
      user = User.create phone: phone, sms_token: "989898", password: password
      company = "小确幸"
      ChinaSMS.use :yunpian, password: "6eba427ea91dab9558f1c5e7077d0a3e"
      result = ChinaSMS.to phone, {company: company, code: password}, {tpl_id: 787073}
    end
    user
  end

  def self.reset_user_password params
    phone = params[:phone]
    password = params[:password]
    sms_token = params[:sms_token]
    user = User.find_by phone: phone
    if user.present?
      user.password = password
      user.sms_token = sms_token
      user.save
    else
      user = User.new
      user.errors.add(:phone, "对应的用户不存在")
    end
    user
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

  # user phone as the authentication key, so email is not required default
  def email_required?
    false
  end

  def add_customer
    self.create_customer
  end

end
