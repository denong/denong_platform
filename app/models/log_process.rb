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
      sheet.add_row ["姓名", "手机号", "身份证", "小金", "兑换时间", "唯一标示"]

      logs.each do |log|
        name = log.try(:customer).try(:customer_reg_info).try(:name)
        phone = log.try(:customer).try(:user).try(:phone)
        id_card = log.try(:customer).try(:customer_reg_info).try(:id_card)
        point = log.try(:jajin)
        time = log.try(:created_at).strftime("%Y%m%d%H%M%S")
        unique_ind = log.try(:unique_ind)
        sheet.add_row([name, phone, id_card, point, time, unique_ind], :types => [:string, :string, :string, :string, :string, :string])
      end
      file.use_shared_strings = true
      file.serialize("#{logs_folder}/#{start_time.strftime("%m%d")}到#{end_time.strftime("%m%d")}.xlsx")
    end
    "#{logs_folder}/#{start_time.strftime("%m%d")}到#{end_time.strftime("%m%d")}.xlsx"
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
        next if log.try(:customer).try(:customer_reg_info).try(:verify_state) != "verified"

        shop_ind = log.try(:shop_ind)
        pos_ind = log.try(:pos_ind)
        trade_date = log.try(:trade_time)[0..7]
        trade_time = log.try(:trade_time)[-6..-1]
        price = log.try(:price)
        phone = log.try(:phone)
        card = log.try(:card)
        name = log.try(:customer).try(:customer_reg_info).try(:name)
        sheet.add_row([shop_ind, pos_ind, trade_date, trade_time, price, phone, card, name], :types => [:string, :string, :string, :string, :string, :string, :string, :string])
      end
      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}.xlsx")
    end
    return "#{logs_folder}/#{filename}.xlsx", logs.size
  end

  def self.export_user_info_by_merchant merchant_id, start_time, end_time
    users = User.where(user_source: 0, source_id: merchant_id, created_at: start_time..end_time)

    merchant = Merchant.find_by(id: merchant_id)
    filename = "#{Time.now.to_date}-#{merchant.try(:sys_reg_info).try(:sys_name)}.xlsx"
    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    file = Axlsx::Package.new

    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["手机号", "姓名", "身份证", "小金", "注册时间"]

      users.each do |user|

        phone = user.try(:phone)
        name = user.try(:customer).try(:customer_reg_info).try(:name)
        id_card = user.try(:customer).try(:customer_reg_info).try(:id_card)
        jajin = user.try(:customer).try(:jajin).try(:got)
        created_time = user.try(:created_at).try(:to_s)

        sheet.add_row([phone, name, id_card, jajin, created_time], :types => [:string, :string, :string, :string, :string])
      end
      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}")
    end

    return "#{logs_folder}/#{filename}", users.size
  end

  def self.export_tl_trade_account_user start_time, end_time
    logs = TlTrade.where(created_at: start_time..end_time)
    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    file = Axlsx::Package.new
    filename = "#{start_time.strftime("%m%d")}到#{end_time.strftime("%m%d")}"
    write_rows = []
    logs.each do |log|
      next if log.try(:customer).try(:customer_reg_info).try(:verify_state) != "verified"

      # 姓名， 身份证号码， 手机号， 小金
      name = log.try(:customer).try(:customer_reg_info).try(:name)
      id_card = log.try(:customer).try(:customer_reg_info).try(:id_card)
      phone = log.try(:phone)
      jajin = log.try(:customer).try(:jajin).try(:got)
      write_rows << [name, id_card, phone, jajin]
    end
    
    write_rows.uniq!

    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["姓名", "身份证号码", "手机号", "小金"]

      write_rows.each do |row|
        sheet.add_row(row, :types => [:string, :string, :string, :string])
      end
      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}.xlsx")
    end
    return "#{logs_folder}/#{filename}.xlsx", write_rows.size
  end

  # LogProcess.export_zjht_data
  def self.export_zjht_data
    logs = JajinVerifyLog.where(merchant_id: 136)
    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    file = Axlsx::Package.new
    filename = "中经汇通#{DateTime.now.strftime("%m%d")}"
    write_rows = []
    logs.each do |log|
      # 姓名， 身份证号码， 手机号， 小金
      name = log.try(:customer).try(:customer_reg_info).try(:name)
      id_card = log.try(:customer).try(:customer_reg_info).try(:id_card)
      phone = log.try(:customer).try(:user).try(:phone)
      jajin = log.try(:customer).try(:jajin_verify_logs).where(merchant_id: 136).sum(:amount)
      write_rows << [name, id_card, phone, jajin]
    end
    
    write_rows.uniq!

    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["姓名", "身份证号码", "手机号", "小金"]

      write_rows.each do |row|
        sheet.add_row(row, :types => [:string, :string, :string, :string])
      end
      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}.xlsx")
    end
    return "#{logs_folder}/#{filename}.xlsx", write_rows.size
  end

  # LogProcess.export_id_card_info
  def self.export_id_card_info

    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    filename = "用户实名制信息#{DateTime.now.strftime("%m%d")}"

    book = Spreadsheet.open "public/大吃一金活动短信名单.xls"

    phones = []
    sheet = book.worksheet 0
    sheet.each do |row|
      phones << row[0].to_i.to_s
    end

    write_rows = []

    phones.each do |phone|
      user = User.find_by(phone: phone)

      phone = phone
      name = user.try(:customer).try(:customer_reg_info).try(:name)
      id_card = user.try(:customer).try(:customer_reg_info).try(:id_card)

      write_rows << [phone, name, id_card]
    end

    write_rows.uniq!

    file = Axlsx::Package.new
    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["手机号", "姓名", "身份证号码", "手机号"]

      write_rows.each do |row|
        sheet.add_row(row, :types => [:string, :string, :string, :string])
      end
      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}.xlsx")
    end
    return "#{logs_folder}/#{filename}.xlsx", write_rows.size
  end

  def self.export_tl_trade_repeat start_time, end_time
    logs = MemberCardPointLog.where(created_at: start_time..end_time)
    member_cards = logs.group(:member_card_id).pluck(:member_card_id)
    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    filename = "#{start_time.strftime("%m%d")}到#{end_time.strftime("%m%d")}重复兑换情况"
    write_rows = []

    member_cards.each do |card_id|
      member_card = MemberCard.find_by(id: card_id)
      next unless member_card.present?
      next unless member_card.member_card_point_logs.present?

      log_size = member_card.member_card_point_logs.where(created_at: start_time..end_time).size
      next if log_size <= 1

      phone = member_card.try(:customer).try(:user).try(:phone)
      name = member_card.try(:customer).try(:customer_reg_info).try(:name)
      id_card = member_card.try(:customer).try(:customer_reg_info).try(:id_card)
      jajin = member_card.try(:customer).try(:jajin).try(:got)

      write_rows << [phone, name, id_card, jajin, log_size]
    end

    write_rows.uniq!

    file = Axlsx::Package.new
    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["手机号", "姓名", "身份证号码", "小金", "重复兑换次数"]

      write_rows.each do |row|
        sheet.add_row(row, :types => [:string, :string, :string, :string, :string])
      end

      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}.xlsx")
    end

    return "#{logs_folder}/#{filename}.xlsx", write_rows.size
  end
end
