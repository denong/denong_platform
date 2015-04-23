# == Schema Information
#
# Table name: jajin_verify_logs
#
#  id          :integer          not null, primary key
#  amount      :float
#  verify_code :string(255)
#  verify_time :datetime
#  customer_id :integer
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class JajinVerifyLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
  has_one :jajin_log, as: :jajinable

  validates_presence_of :customer, on: :create
  validate :must_have_verify_code, on: :create
  before_save :calculate
  before_save :add_jajin_log

  def as_json(options=nil)
    {
      
    }
  end

  private

    def must_have_verify_code
      identity_code = JajinIdentityCode.find(identity_code: verify_code)
      if identity_code.nil?
        errors.add(:message, "该加金验证码不存在")
      elsif verify_time > identity_code.expiration_time
        errors.add(:message, "该加金验证码已过期")
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
