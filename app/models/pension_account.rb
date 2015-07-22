# == Schema Information
#
# Table name: pension_accounts
#
#  id          :integer          not null, primary key
#  id_card     :string(255)
#  state       :integer          default(0)
#  customer_id :integer
#  account     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class PensionAccount < ActiveRecord::Base
  belongs_to :customer

  enum state: [ :wait_verify, :success, :fail]
end
