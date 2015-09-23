class LogProcess

  def self.write_log_to_file key
    @results = $redis.hvals(key)
    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    file = Axlsx::Package.new
    file.workbook.add_worksheet(:name => "错误日志") do |sheet|
      sheet.add_row ["手机", "身份证号", "姓名", "交易标示", "兑换积分", "错误原因"]

      @results.each_with_index do |result, index|
        result = eval result
        # sheet.add_row(result.to_a.map { |e| "#{e[-1]}" }, :types => [:string, :string, :string, :string, :string, :string])
        sheet.add_row([result["手机号"], result["身份证号"], result["姓名"], result["交易的唯一标示"], result["兑换积分数"], result["错误原因"]], :types => [:string, :string, :string, :string, :string, :string])
      end
      
      file.use_shared_strings = true
      file.serialize("#{logs_folder}/#{key}.xlsx")
    end
    "#{logs_folder}/#{key}.xlsx"
  end

  def self.export_member_card_log start_time, end_time
    logs = MemberCardPointLog.where(created_at: start_time..end_time)
    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    file = Axlsx::Package.new
    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["姓名", "手机号", "身份证", "小金", "兑换时间"]

      logs.each do |log|
        name = log.try(:customer).try(:customer_reg_info).try(:name)
        phone = log.try(:customer).try(:user).try(:phone)
        id_card = log.try(:customer).try(:customer_reg_info).try(:id_card)
        point = log.try(:jajin)
        time = log.try(:created_at).strftime("%Y%m%d%H%M%S")
        sheet.add_row([name, phone, id_card, point, time], :types => [:string, :string, :string, :string, :string, :string])
      end
      file.use_shared_strings = true
      file.serialize("#{logs_folder}/#{start_time}到#{end_time}.xlsx")
    end
    "#{logs_folder}/#{start_time}到#{end_time}.xlsx"
  end


  def self.export_tl_trade start_time, end_time
    logs = TlTrade.where(created_at: start_time..end_time)
    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    file = Axlsx::Package.new
    filename = "#{start_time.strftime("%m%d")}到#{end_time.strftime("%m%d")}"
    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["商户号", "终端号", "交易日期", "交易时间", "交易金额", "手机号", "交易卡号", "姓名"]

      logs.each do |log|
        next if log.try(:customer).try(:customer_reg_info).try(:verify_state) != 2

        shop_ind = log.try(:shop_ind)
        pos_ind = log.try(:pos_ind)
        trade_date = log.try(:trade_time)[0..7]
        trade_time = log.try(:trade_time)[-6..-1]
        price = log.try(:price)
        phone = log.try(:phone)
        card = log.try(:card)
        name = log.try(:customer).try(:customer_reg_info).try(:name)
        sheet.add_row([name, phone, id_card, point, time], :types => [:string, :string, :string, :string, :string, :string])
      end
      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}.xlsx")
    end
    return "#{logs_folder}/#{filename}.xlsx", logs.size
  end
end
