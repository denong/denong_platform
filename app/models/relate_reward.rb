# == Schema Information
#
# Table name: relate_rewards
#
#  id          :integer          not null, primary key
#  phone       :string(255)
#  verify_code :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class RelateReward < ActiveRecord::Base

  def self.give_reward(phone)
    user = User.where(phone: phone).first
    if user.present?
      relate_reward = RelateReward.where(phone: phone).first
      if relate_reward.present?
        reward = Reward.where(verify_code: relate_reward.verify_code).first
        user.customer.jajin.got += reward.amount
        user.customer.jajin.save
        relate_reward.delete
      end
    end
  end
end
