# == Schema Information
#
# Table name: exchange_logs
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#

class ExchangeLog < ActiveRecord::Base
  belongs_to :customer
  has_one :jajin_log, as: :jajinable

  validates_presence_of :customer, on: :create
  validate :must_have_jajin, on: :create
  validate :must_have_pension, on: :create
  validate :amount_must_less_than_jajin_got, on: :create

  after_validation :calculate
  after_validation :add_jajin_log
  
  private
    def must_have_jajin
      if self.customer.try(:jajin).blank?
        errors.add(:message, "加金宝账号不存在")
      end
    end

    def must_have_pension
      if self.customer.try(:pension).blank?
        errors.add(:message, "养老金账号不存在")
      end
    end

    def amount_must_less_than_jajin_got 
      jajin_got = self.customer.try(:jajin).try(:got)
      if self.amount > jajin_got.to_f
        errors.add(:amount, "不能大于加金可用余额")
      end
    end

    def calculate
      return unless self.customer.jajin
      jajin = self.customer.jajin
      jajin.got -= amount
      jajin.save!
    end

    def add_jajin_log
      self.create_jajin_log customer: customer, amount: amount
    end
end

