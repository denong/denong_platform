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
#  amount      :float
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

  def company
    "奖励送金"
  end

  private
    def must_reward_status      
      reward = Reward.find_by verify_code: verify_code
      if reward.blank?
        errors.add(:verify_code, "该奖励小金不存在或已失效")
      else
        reward.activate_by_customer customer
        self.amount = reward.amount
        self.merchant_id = reward.merchant_id
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
