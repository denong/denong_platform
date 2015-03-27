# == Schema Information
#
# Table name: pensions
#
#  id          :integer          not null, primary key
#  account_id  :integer
#  total       :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Pension < ActiveRecord::Base
  belongs_to :customer
end
