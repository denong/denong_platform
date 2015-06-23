# == Schema Information
#
# Table name: pension_logs
#
#  id           :integer          not null, primary key
#  customer_id  :integer
#  jajin_amount :float
#  amount       :float
#  created_at   :datetime
#  updated_at   :datetime
#

class PensionLog < ActiveRecord::Base
  belongs_to :customer
end
