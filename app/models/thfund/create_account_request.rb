module Thfund
  class CreateAccountRequest

    def initialize()
      @type = "create_account_request"
    end

    def write_file
      file = WriteFileInteractor.new(@type)
      file.write_datas test_datas
      file.close
    end

    def test_datas
      (0..10).map do |index|
        account = Account.new
        account.id = index
        account.certification_no = "1348681764823476" 
        account.inverstor_name = "测试账户"
        account.transaction_date = Time.zone.today.strftime('%Y%m%d')
        account.mobile = "18818188188"
        account.transaction_time = Time.zone.now.strftime('%H%M%S')
        account
      end
    end
    
  end

  class Account
    attr_accessor :id, :certification_no, :inverstor_name, :transaction_date, :mobile, :transaction_time

    def as_json option=nil
      {
        "AppSheetSerialNo" => id,
        "CertificateType" => 0,
        "CertificateNo" => certification_no.to_s.upcase, 
        "InvestorName" => inverstor_name,
        "TransactionDate" => transaction_date,
        "IndividualOrInstitution" => 1,
        "TransactionAccountID" => 242,
        "BusinessCode" => 1,
        "DepositAcct" => "",
        "MobileTelNo" => mobile,
        "TransactionTime" => transaction_time
      }
    end
  end
  
end