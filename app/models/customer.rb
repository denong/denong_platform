# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  pension    :float
#  jiajin     :float
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  belongs_to :user
  has_one :customer_reg_info
end
