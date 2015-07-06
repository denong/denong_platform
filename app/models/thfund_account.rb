# == Schema Information
#
# Table name: thfund_accounts
#
#  id                 :integer          not null, primary key
#  sn                 :integer
#  certification_type :integer
#  certification_no   :string(255)
#  name               :string(255)
#  transaction_time   :datetime
#  account_id         :integer
#  mobile             :string(255)
#  customer_id        :integer
#  state              :integer
#  created_at         :datetime
#  updated_at         :datetime
#  return_code        :integer
#

class ThfundAccount < ActiveRecord::Base
  belongs_to :customer

  enum state: [ :wait_verify, :success, :fail]

  after_create :init_attributes


  def self.create_accounts
    verifies = IdentityVerify.where(account_state: 0, verify_state: 2)
    accounts = []
    verifies.each do |verify_entry|
      account = ThfundAccount.new
      customer = verify_entry.customer
      account.mobile = customer.try(:user).try(:phone)
      account.customer = customer
      account.name = verify_entry.name
      account.certification_no = verify_entry.id_card
      account.transaction_time = Time.zone.now
      account.save

      verify_entry.created!
      accounts << account
    end

    if accounts.present?
      file = Thfund::WriteFileInteractor.new("create_account_request")
      file.write_datas accounts
      file.close
    end
  end

  def self.create_by_phone phone
    user = User.find_by phone: phone
    self.create_by_customer user.customer if user.try(:customer).present?
  end

  def self.create_by_customer customer
    account = ThfundAccount.new
    account.mobile = customer.try(:user).try(:phone)
    account.customer = customer
    account.name = customer.try(:customer_reg_info).try(:name)
    account.customer_reg_info = customer.try(:customer_reg_info).try(:id_card)
    account.transaction_time = Time.zone.now
    account.save

    account.return_code = 0
    account.save

    account.success!

    # 创建用户的养老金账户
    customer = account.customer
    if customer.present?
      account_string = account.id.to_s.rjust(10, '0')
      customer.create_pension(total: 0, account: account_string)
    end

    # 发送SMS消息
    account.send_sms_notification
  end

  def as_json(options=nil)
    {
      "AppSheetSerialNo" => sn,
      "CertificateType" => 0,
      "CertificateNo" => certification_no, 
      "InvestorName" => name,
      "TransactionDate" => transaction_time.strftime('%Y%m%d'),
      "IndividualOrInstitution" => 1,
      "TransactionAccountID" => id,
      "BusinessCode" => 1,
      "DepositAcct" => "",
      "MobileTelNo" => mobile,
      "TransactionTime" => transaction_time.strftime('%H%M%S')
    }
  end

  def self.confirm_account confirm_hash
    sn = confirm_hash["AppSheetSerialNo"].to_i
    account = ThfundAccount.find_by sn: sn
    if account.present?
      account.return_code = confirm_hash["ReturnCode"].to_i
      account.save
      if account.return_code == 0
        account.success!

        # 创建用户的养老金账户
        customer = account.customer
        if customer.present?
          account_string = account.id.to_s.rjust(10, '0')
          customer.create_pension(total: 0, account: account_string)
        end

        # 发送通知消息
        account.send_xg_notification

        # account.account_id = confirm_hash["TAAccountID"]
      else
        account.fail!
      end
    end
    account
  end

  def send_xg_notification
    user = customer.try(:user)
    if user.present? && user.os.present? && user.device_token.present?
      account_string = id.to_s.rjust(10, '0')
      content = "您的消费养老金账户已经开户成功，账号是#{account_string}"
      params = {}
      custom_content = {
        account: account_string
      }
      sender = nil
      if user.os.to_s.downcase.to_sym == :android
        # custom_content.merge!({
        #     action: {
        #       action_type: 1,
        #       activity: "net.izhuo.app.happilitt.MessageDetailActivity"
        #     }
        #   })
        sender = Xinge::Notification.instance.android
      elsif user.os.to_s.downcase.to_sym == :ios
        sender = Xinge::Notification.instance.ios
      end
      response = sender.pushToSingleDevice user.device_token, message.title, content, params, custom_content
      logger.info "sended xg notification #{id}, response is: #{response.inspect}"
    end
  end


  def send_sms_notification
    user = customer.try(:user)
    if user.present?
      company = "德浓消费养老"
      ChinaSMS.use :yunpian, password: "6eba427ea91dab9558f1c5e7077d0a3e"
      account_string = id.to_s.rjust(10, '0')
      code = account_string
      result = ChinaSMS.to phone, {company: company, code: token}, {tpl_id: 2}
    end
  end

  private
    def init_attributes
      self.sn ||= id * 1000 + 1
      self.wait_verify!
    end

end
