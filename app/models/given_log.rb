# == Schema Information
#
# Table name: given_logs
#
#  id                :integer          not null, primary key
#  giver_or_given_id :integer
#  amount            :float
#  created_at        :datetime
#  updated_at        :datetime
#  customer_id       :integer
#

class GivenLog < ActiveRecord::Base
  has_one :jajin_log, as: :jajinable

  private
      
end
