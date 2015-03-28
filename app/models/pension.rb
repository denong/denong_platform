# == Schema Information
#
# Table name: pensions
#
#  id          :integer          not null, primary key
#  total       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  account     :integer
#

class Pension < ActiveRecord::Base
  belongs_to :customer
end
