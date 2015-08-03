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

      next if PensionAccount.find_by_id_card(identity_verify.id_card).present?

      self.create_by_customer identity_verify.customer
      sleep 0.5
    end

  end

  def self.create_by_identity_info_and_num create_num
    verifies = IdentityVerify.where(account_state: 0, verify_state: 2)
    accounts = []
    i = 0
    verifies.each do |identity_verify|
      i+=1
      break if i >= create_num
      next if PensionAccount.find_by_id_card(identity_verify.id_card).present?
      puts "id_card is #{identity_verify.id_card}, customer is #{identity_verify.try(:customer).try(:user).try(:phone)}"
      self.create_by_customer identity_verify.customer
      sleep 0.5
    end
  end

  def self.create_by_phone phone
    user = User.find_by phone: phone
    self.create_by_customer user.customer if user.try(:customer).present? && !(user.try(:customer).try(:pension).present?)
  end

  def self.create_by_customer customer
    account = PensionAccount.new

    customer.try(:identity_verifies).try(:last).try(:created!)

    account.customer = customer
    account.phone = customer.try(:user).try(:phone)
    account.name = customer.try(:customer_reg_info).try(:name)
    account.id_card = customer.try(:customer_reg_info).try(:id_card)
    account.save
    account.success!
    
    # 创建用户的养老金账户
    customer = account.customer
    if customer.present?
      account_string = account.id.to_s.rjust(10, '0')
      customer.create_pension(total: 0, account: account_string)
      customer.customer_reg_info.success!
      customer.identity_verifies.last.success!
    end

    # 发送SMS消息
    account.send_sms_notification
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
