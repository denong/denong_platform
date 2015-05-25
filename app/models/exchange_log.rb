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

  before_save :calculate
  before_save :add_jajin_log

  def as_json(options=nil)
    {
      status: "ok"
    }
  end

  def company
    "小金互赠"
  end
  
  private
    def must_have_jajin
      if self.customer.try(:jajin).blank?
        errors.add(:message, "小确幸账号不存在")
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
        errors.add(:amount, "不能大于小金可用余额")
      end
    end

    def calculate
      decrease_jajin
      increase_pension
    end

    def decrease_jajin
      jajin = self.customer.jajin
      jajin.got -= amount
      jajin.save!
    end

    def increase_pension
      pension = self.customer.pension
      pension.total += amount/100
      pension.save!
    end


    def add_jajin_log
      self.create_jajin_log customer: customer, amount: amount
    end
end

