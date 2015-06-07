module Thfund
  class CreateAccountRequest

    def initialize()
      @type = "create_account_request"
      @code = ThfundSettings.send(@type).code
      @params = ThfundSettings.send(@type).params.keys
    end

    def write_file
      file = FileInteractor.new
      file.write_file_header
      file.puts @params.count
      @params.each { |param| file.puts(param) }

      accounts = test_datas
      file.puts accounts.count
      accounts.each do |account|
        content = ""
        account_hash = account.as_json
        @params.each do |param|
          if account_hash[param].present?
            content = file.write_attribute("create_account_request", content, param, account_hash[param])
          else
            content = file.write_attribute("create_account_request", content, param, "")
          end
        end
        
        # content = file.write_attribute("create_account_request", content, "CertificateType", 0)
        # content = file.write_attribute("create_account_request", content, "CertificateNo", account.certification_no)
        # content = file.write_attribute("create_account_request", content, "InvestorName", account.inverstor_name)
        # content = file.write_attribute("create_account_request", content, "TransactionDate", account.transaction_date)
        # content = file.write_attribute("create_account_request", content, "IndividualOrInstitution", 1)
        # content = file.write_attribute("create_account_request", content, "TransactionAccountID", 242)
        # content = file.write_attribute("create_account_request", content, "BusinessCode", 1)
        # content = file.write_attribute("create_account_request", content, "DepositAcct", "")
        # content = file.write_attribute("create_account_request", content, "MobileTelNo", account.mobile)
        # content = file.write_attribute("create_account_request", content, "TransactionTime", account.transaction_time)
        file.puts content
      end

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
        "CertificateNo" => certification_no, 
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