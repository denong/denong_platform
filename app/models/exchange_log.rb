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
  
  private
    def must_have_jajin
      if record.customer.try(:jajin).blank?
        errors.add(:message, "加金宝帐号不存在")
      end
    end

    def must_have_pension
      if record.customer.try(:pension).blank?
        errors.add(:message, "养老金帐号不存在")
      end
    end

    def amount_must_less_than_jajin_got record
      jajin_got = record.customer.try(:jajin).try(:got)
      if record.amount > jajin_got.to_f
        record.errors.add(:amount, "不能大于加金可用余额")
      end
    end

    def calculate
      jajin = record.customer.jajin
      jajin.got -= amount
      jajin.save!
    end
end

