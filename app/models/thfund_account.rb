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


  def as_json(options=nil)
    {
      "AppSheetSerialNo" => sn,
      "CertificateType" => 0,
      "CertificateNo" => certification_no, 
      "InvestorName" => name,
      "TransactionDate" => transaction_time.strftime('%Y%m%d'),
      "IndividualOrInstitution" => 1,
      "TransactionAccountID" => 242,
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
      if account.return_code == 0
        account.success!
        account.account_id = confirm_hash["TAAccountID"]
      else
        account.fail!
      end
    end
    account
  end

  private
    def init_attributes
      self.sn ||= id * 1000 + 1
      self.wait_verify!
    end
end
