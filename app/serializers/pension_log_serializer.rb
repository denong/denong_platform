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

class PensionLogSerializer < ActiveModel::Serializer
  attributes :id
end
