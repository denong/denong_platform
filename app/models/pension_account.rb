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
#  phone       :string(255)
#  name        :string(255)
#

class PensionAccount < ActiveRecord::Base
  belongs_to :customer

  enum state: [ :wait_verify, :success, :fail]

  after_create :add_account_info

  def add_account_info
    self.account = id.to_s.rjust(10, '0')
    customer.create_pension(total: 0, account: account)
  end

end
