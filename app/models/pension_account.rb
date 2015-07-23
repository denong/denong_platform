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

  enum state: [ :not_created, :success, :processing, :fail]

  after_create :add_account_info

  def self.create_by_identity_info
    verifies = IdentityVerify.where(account_state: 2, verify_state: 2)
    accounts = []
    verifies.each do |identity_verify|

      account = PensionAccount.new
      account.name = identity_verify.name
      account.id_card = identity_verify.id_card
      account.phone = identity_verify.customer.user.phone
      account.customer = identity_verify.customer
      account.state = identity_verify.account_state
      account.save

      accounts << account
    end

  end

  def add_account_info
    self.account = id.to_s.rjust(10, '0')
  end

  def success
    customer.create_pension(total: 0, account: account)
    self.customer.identity_verifies.last.success!
    success!
  end

  def failed
    self.customer.identity_verifies.last.fail!
    fail!
  end
end
