# == Schema Information
#
# Table name: given_logs
#
#  id                :integer          not null, primary key
#  giver_or_given_id :integer
#  amount            :float(24)
#  created_at        :datetime
#  updated_at        :datetime
#  customer_id       :integer
#

class GivenLog < ActiveRecord::Base
  has_one :jajin_log, as: :jajinable
  belongs_to :customer

  validates_presence_of :customer, on: :create
  validate :check_user, on: :create
  validate :must_have_jajin, on: :create
  validate :amount_must_less_than_jajin_got, on: :create  

  before_save :calculate
  before_save :add_jajin_log

  def as_json(options=nil)
    {
      
    }
  end

  def self.add_both_given_log giver_customer, given_customer, amount
    return if giver_customer.nil? || given_customer.nil?
    given_log = self.create(customer: given_customer, giver_or_given_id: giver_customer.id, amount: amount)
    giver_log = self.create(customer: giver_customer, giver_or_given_id: given_customer.id, amount: -1*amount)
    return giver_log, given_log
  end

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

  def amount_must_less_than_jajin_got 
    jajin_got = self.customer.try(:jajin).try(:got)
    if self.amount < 0 && self.amount.abs > jajin_got.to_f
      errors.add(:amount, "不能大于小金可用余额")
    end
  end    

  def calculate
    jajin = self.customer.jajin
    jajin.got += amount
    jajin.save!
  end

  def add_jajin_log
    self.create_jajin_log customer: customer, amount: amount
  end
  
end
