# == Schema Information
#
# Table name: pension_logs
#
#  id           :integer          not null, primary key
#  customer_id  :integer
#  jajin_amount :float
#  amount       :float
#  created_at   :datetime
#  updated_at   :datetime
#

class PensionLog < ActiveRecord::Base

  scope :in, -> { where "amount > 0" }
  scope :out, -> { where "amount < 0" }

  belongs_to :customer

  has_one :jajin_log, as: :jajinable

  after_create :calculate
  after_create :add_jajin_log

  validates_presence_of :customer, on: :create
  validate :must_jajin_amount_negative, on: :create
  validate :must_have_jajin, on: :create
  validate :must_have_pension, on: :create
  validate :amount_must_less_than_jajin_got, on: :create

  def as_json(options=nil)
    {
      amount: amount,
      jajin_amount: jajin_amount
    }
  end

  def self.change_all_jajin_to_pension
    pensions = Pension.all
    pensions.each do |pension|
      customer = pension.customer
      if customer.jajin.got > 0
        pension_logs = customer.pension_logs.create(jajin_amount: (customer.jajin.got*-1))
      end
    end
  end

  def self.change_jajin_to_pension customer_id

    customer = Customer.find(customer_id)
    if customer.jajin && customer.pension && customer.jajin.got > 0
      customer.pension_logs.create(jajin_amount: (customer.jajin.got*-1))
    end

  end

  def company
    "小金转养老金"
  end

  private
    def must_jajin_amount_negative
      unless jajin_amount < 0
        errors.add(:jajin_amount, "必须小于0")
      end
      self.amount = jajin_amount.abs/100
    end

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
      if self.jajin_amount > jajin_got.to_f
        errors.add(:jajin_amount, "不能大于小金可用余额")
      end
    end

    def calculate
      decrease_jajin
      increase_pension
    end

    def decrease_jajin
      jajin = self.customer.jajin
      jajin.got += jajin_amount
      jajin.save!
    end

    def increase_pension
      pension = self.customer.pension
      pension.total += amount
      pension.save!
    end

    def add_jajin_log
      self.create_jajin_log customer: customer, amount: jajin_amount
    end

end
