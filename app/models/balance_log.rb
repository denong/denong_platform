# == Schema Information
#
# Table name: balance_logs
#
#  id          :integer          not null, primary key
#  jajin       :float
#  balance     :float
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class BalanceLog < ActiveRecord::Base
  belongs_to :merchant

  scope :in, -> { where "balance > 0" }
  scope :out, -> { where "balance < 0" }

  
end
