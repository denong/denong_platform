module Thfund
  class CreateTradeRequest
    
    def initialize()
      @type = "trade_request"
    end

    def write_file
      file = WriteFileInteractor.new(@type)
      file.write_datas test_datas
      file.close
    end

    def test_datas
      (511..523).map do |index|
        trade = Trade.new
        trade.id = index
        trade.account_id = index
        trade.amount = index * 1.0 / 100
        trade
      end
    end

  end

  class Trade
    attr_accessor :id, :amount, :account_id

    def as_json option=nil
      {
        "AppSheetSerialNo" => id,
        "FundCode" => "420006",
        "TransactionDate" => Time.zone.today.strftime('%Y%m%d'),
        "TransactionTime" =>Time.zone.now.strftime('%H%M%S'),
        "TransactionAccountID" => account_id,
        "ApplicationVol" => 0,
        "ApplicationAmount" => amount,
        "BusinessCode" => 22
      }
    end
  end
end