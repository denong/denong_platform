# == Schema Information
#
# Table name: given_logs
#
#  id         :integer          not null, primary key
#  giver_id   :integer
#  given_id   :integer
#  amount     :float
#  created_at :datetime
#  updated_at :datetime
#

class GivenLog < ActiveRecord::Base
  has_one :jajin_log, as: :jajinable
end
