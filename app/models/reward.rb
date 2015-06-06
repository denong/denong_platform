# == Schema Information
#
# Table name: rewards
#
#  id          :integer          not null, primary key
#  amount      :float
#  verify_code :string(255)
#  max         :integer
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Reward < ActiveRecord::Base
  belongs_to :merchant
end
