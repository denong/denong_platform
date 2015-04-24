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
  validate :must_verify_state_sucess, on: :create
  before_save :calculate
  before_save :add_jajin_log

  def as_json(options=nil)
    {
      
    }
  end

  private

    def must_verify_state_sucess
      verify_rlt = JajinIdentityCode.activate_by_verify_code verify_code
      unless verify_rlt
        errors.add(:message, "该加金验证码不存在或已失效")
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
