# == Schema Information
#
# Table name: tl_trades
#
#  id          :integer          not null, primary key
#  phone       :string(255)
#  card        :string(255)
#  price       :float
#  trade_time  :datetime
#  pos_ind     :string(255)
#  shop_ind    :string(255)
#  trade_ind   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#  merchant_id :integer
#

class TlTrade < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
  has_one :jajin_log, as: :jajinable

  validates_presence_of :customer, on: :create
  validates_presence_of :merchant, on: :create

  before_validation :check_user, on: :create, if: "customer.nil?"
  validate :must_have_jajin, on: :create
  validates :phone, length: { is: 11 }

  before_save :calculate
  before_save :add_jajin_log

  private

  def check_user
    user = User.find_by_phone(phone)
    if user.nil?
      user = User.create! phone: phone, sms_token: "989898", password: "12345678"
    end
    self.customer = user.customer
  end

  def must_have_jajin
    if self.customer.try(:jajin).blank?
      errors.add(:message, "加金宝账号不存在")
    end
  end

  def must_have_merchant
    if self.try(:merchant).blank?
      errors.add(:message, "商户不存在")
    end
  end

  def calculate
    jajin = self.customer.jajin
    jajin.got += (self.merchant.ratio*price)
    jajin.save!
  end

  def add_jajin_log
    self.create_jajin_log customer: customer, amount: self.merchant.ratio*price
  end

end
