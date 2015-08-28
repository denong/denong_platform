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
#  company     :string(255)
#

class JajinVerifyLog < ActiveRecord::Base
  attr_accessor :phone

  belongs_to :customer
  belongs_to :merchant
  has_one :jajin_log, as: :jajinable

  validates_presence_of :customer, on: :create
  validate :must_verify_state_sucess, on: :create
  before_create :generate_verify_time
  after_create :calculate
  after_create :add_jajin_log

  def as_json(options=nil)
    {
      company: company,
      verify_code: verify_code
    }
  end

  def self.tl_varify params
    check_result = false
    jajin_identity_code = JajinIdentityCode.find_by_verify_code(params[:ckh])

    if jajin_identity_code && (params[:date] == jajin_identity_code.trade_time[0..7]) &&
      (params[:time] == jajin_identity_code.trade_time[8..13]) &&
      (params[:amt].to_f == jajin_identity_code.amount.to_f)
      check_result = true
    end
    check_result
  end

  private

    def must_verify_state_sucess
      verify_identity = JajinIdentityCode.activate_by_verify_code verify_code
      unless verify_identity.present?
        errors.add(:verify_code, "该小金验证码不存在或已失效")
      else
        # 需要从原始串码内容中获取相关的小金内容
        self.amount = verify_identity.amount
        # self.company = verify_identity.company
        self.merchant_id = verify_identity.merchant_id
        if self.merchant_id.nil?
          self.company = verify_identity.company
        else
          self.company = "扫码送金"
        end
      end
    end

    def calculate
      jajin = self.customer.jajin
      jajin.got += amount
      jajin.save!
    end

    def add_jajin_log
      self.create_jajin_log customer: customer, amount: amount, merchant_id: merchant_id
    end

    def generate_verify_time
      self.verify_time = DateTime.now
    end
end
