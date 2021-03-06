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

  # PensionAccount.create_by_identity_info
  def self.create_by_identity_info
    verifies = CustomerRegInfo.where(account_state: 0, verify_state: 2)
    accounts = []
    i = 0
    verifies.each do |identity_verify|
      i+=1
      logger.info "try this is the #{i} one, id_card is #{identity_verify.id_card}, customer is #{identity_verify.try(:customer).try(:user).try(:phone)}"
      if (identity_verify.customer.try(:user).present?) && (PensionAccount.find_by_id_card(identity_verify.id_card).present? ||
        PensionAccount.find_by_phone(identity_verify.customer.try(:user).try(:phone)).present?)
        identity_verify.customer.customer_reg_info.fail!
        identity_verify.customer.identity_verifies.last.fail!
        next
      end
      self.create_by_customer identity_verify.customer
      sleep 0.1
    end
  end

  def self.create_by_identity_info_and_num create_num
    verifies = CustomerRegInfo.where(account_state: 0, verify_state: 2)
    accounts = []
    i = 0
    iSuccess = 0
    verifies.each do |identity_verify|
      i+=1
      break if i > create_num
      puts "try this is the #{i} one, id_card is #{identity_verify.id_card}, customer is #{identity_verify.try(:customer).try(:user).try(:phone)}"
      if (identity_verify.customer.try(:user).present?) && (PensionAccount.find_by_id_card(identity_verify.id_card).present? ||
        PensionAccount.find_by_phone(identity_verify.customer.try(:user).try(:phone)).present?)
        identity_verify.customer.customer_reg_info.fail!
        identity_verify.customer.identity_verifies.last.fail!
        next
      end
      puts "start this is the #{i} one, id_card is #{identity_verify.id_card}, customer is #{identity_verify.try(:customer).try(:user).try(:phone)}"
      self.create_by_customer identity_verify.customer
      iSuccess += 1
      sleep 0.1
    end

    puts "#{create_num - iSuccess} failed, #{iSuccess} success !"
  end

  def self.create_by_phone phone
    user = User.find_by phone: phone
    self.create_by_customer user.customer if user.try(:customer).present? && !(user.try(:customer).try(:pension).present?)
  end

  def self.create_by_customer customer

    # # 养老金账户，先查找有没有该身份证开户成功的养老金账户
    # pension_account = PensionAccount.find_by(state: 1, id_card: customer.try(:customer_reg_info).try(:id_card))
    # if pension_account.present?
    #   account_string = pension_account.id.to_s.rjust(10, '0')
    #   pension = Pension.find_by(account: account_string)
    #   if pension.present?
    #     puts "find pension account #{account_string} by id card #{customer.try(:customer_reg_info).try(:id_card)}"
    #     puts "original user id is #{pension.try(:customer).try(:user).try(:id)}, current user id is #{customer.try(:user).try(:id)}"
    #     customer.pension = pension
    #     customer.save!
    #     customer.customer_reg_info.success!
    #     customer.identity_verifies.last.success!
    #     return
    #   end
    # end

    # # 养老金账户，查找有没有该手机号开户成功的养老金账户
    # pension_account = PensionAccount.find_by(state: 1, phone: customer.try(:user).try(:phone))
    # if pension_account.present?
    #   account_string = pension_account.id.to_s.rjust(10, '0')
    #   pension = Pension.find_by(account: account_string)
    #   if pension.present?
    #     puts "find pension account #{account_string} by id card #{customer.try(:user).try(:phone)}"
    #     puts "original user id is #{pension.try(:customer).try(:user).id}, current user id is #{customer.try(:user).id}"
    #     customer.pension = pension
    #     customer.save!
    #     customer.customer_reg_info.success!
    #     customer.identity_verifies.last.success!
    #     return
    #   end
    # end

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
    if user.present? && user.try(:source_id) != 28
      # company = "德浓消费养老"
      # ChinaSMS.use :yunpian, password: "6eba427ea91dab9558f1c5e7077d0a3e"
      # account_string = id.to_s.rjust(10, '0')
      # result = ChinaSMS.to user.phone, {account: account_string}, {tpl_id: 875755}

      # 亲爱的用户，恭喜您已成功开通消费养老金账户（0000010032），工商银行查询系统正为您努力升级中，请耐心等待，我们会第一时间提醒您进行查询。
      # 开通消费养老金账号，  【CCPP合格计划】  触发类短信
      account_string = id.to_s.rjust(10, '0')
      content = "尊敬的用户，您已成功认证消费养老金账户，现进入工商银行待开户状态，工行开户成功后，我们将提醒您登录查询，请您耐心等待！"
      TextMessage.send_msg 1, content, user.phone, 1
    end
  end

  def failed
    self.customer.customer_reg_info.fail!
    self.customer.identity_verifies.last.fail!
    fail!
  end
end
