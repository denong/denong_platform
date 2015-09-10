# == Schema Information
#
# Table name: reward_logs
#
#  id          :integer          not null, primary key
#  reward_id   :integer
#  customer_id :integer
#  merchant_id :integer
#  verify_code :string(255)
#  verify_time :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  amount      :float(24)
#  comment     :string(255)
#

class RewardLog < ActiveRecord::Base
  attr_accessor :phone

  belongs_to :reward
  belongs_to :customer
  belongs_to :merchant
  has_one :jajin_log, as: :jajinable

  before_create :generate_verify_time
  after_create :calculate
  after_create :add_jajin_log

  validate :must_reward_status, on: :create
  validate :must_less_than_max, on: :create

  def company
    comment.blank? ? "奖励送金" : comment
  end

  private
    def must_reward_status      
      reward = Reward.find_by(verify_code: verify_code)
      if reward.blank?
        errors.add(:message, "该奖励小金不存在或已失效")
      else
        reward.activate_by_customer customer
        self.amount = reward.amount
        self.comment = reward.comment
        self.merchant_id = reward.merchant_id
      end
    end

    def must_less_than_max
      reward = Reward.find_by verify_code: verify_code

      max = reward.try(:max).to_i
      count = RewardLog.where(verify_code: verify_code, customer_id: customer_id).count
      if count >= max
        errors.add(:message, "抱歉，您无法重复领取该奖励小金")
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
