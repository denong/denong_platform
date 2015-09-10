# == Schema Information
#
# Table name: merchant_giving_logs
#
#  id          :integer          not null, primary key
#  amount      :float(24)
#  giving_time :datetime
#  merchant_id :integer
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  shop_id     :integer
#  consumption :float(24)
#

class MerchantGivingLog < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  has_one :jajin_log, as: :jajinable

  validates_presence_of :customer, on: :create
  validates_presence_of :merchant, on: :create
  validate :check_user, on: :create
  validate :must_have_jajin, on: :create
  validate :amount_must_less_than_jajin_total, on: :create  

  before_save :calculate
  before_save :add_jajin_log

  private

  def check_user
    customer = Customer.find_by_id(customer_id)
    if customer.nil?
      errors.add(:message, "该用户不存在")
    end
  end

  def must_have_jajin
    if self.customer.try(:jajin).blank?
      errors.add(:message, "小确幸账号不存在")
    end
  end

  def amount_must_less_than_jajin_total 
    jajin_total = self.merchant.try(:jajin_total)
    if self.amount < 0 && self.amount.abs > jajin_total.to_f
      errors.add(:amount, "不能大于小金可用余额")
    end
  end

  def calculate
    jajin = self.customer.jajin
    jajin.got += amount
    jajin.save!

    merchant = self.merchant
    merchant.jajin_total -= amount
    merchant.save!
  end

  def add_jajin_log
    self.create_jajin_log customer: customer, amount: amount, merchant: merchant
  end
end
