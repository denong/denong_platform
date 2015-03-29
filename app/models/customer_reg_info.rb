# == Schema Information
#
# Table name: customer_reg_infos
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  name        :string(255)
#  idcard      :string(255)
#  audit_state :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class CustomerRegInfo < ActiveRecord::Base
  belongs_to :customer
end