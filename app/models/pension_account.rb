# == Schema Information
#
# Table name: pension_accounts
#
#  id          :integer          not null, primary key
#  id_card     :string(255)
#  customer_id :integer
#  account     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  phone       :string(255)
#  name        :string(255)
#  state       :integer          default(3)
#

class PensionAccount < ActiveRecord::Base
  belongs_to :customer

  enum state: [ :processing, :success, :fail, :not_created]

  after_create :add_account_info

  def self.create_by_identity_info
    verifies = IdentityVerify.where(account_state: 0, verify_state: 2)
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
    self.save
  end

  def success
    customer.create_pension(total: 0, account: account)
    self.customer.customer_reg_info.success!
    self.customer.identity_verifies.last.success!
    success!
    # 发送SMS消息
    send_sms_notification
  end

  def send_sms_notification
    user = customer.try(:user)
    if user.present?
      company = "德浓消费养老"
      ChinaSMS.use :yunpian, password: "6eba427ea91dab9558f1c5e7077d0a3e"
      account_string = id.to_s.rjust(10, '0')
      result = ChinaSMS.to user.phone, {account: account_string}, {tpl_id: 875755}
    end
  end

  def failed
    self.customer.customer_reg_info.fail!
    self.customer.identity_verifies.last.fail!
    fail!
  end
end
