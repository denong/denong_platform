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

  # LogProcess.export_member_card_log DateTime.new(2015, , ), DateTime.new(2015, , )
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

  def self.get_verify_time phones
    write_rows = []

    phones.each do |phone|
      user = User.find_by(phone: phone)
      next unless user.present?
      identity_verifies = user.try(:customer).try(:identity_verifies)
      next unless identity_verifies.present?
      time = identity_verifies.find_by(verify_state: 2).try(:updated_at).strftime("%Y%m%d")
      row = [phone, time]
      write_rows << row
    end

    logs_folder = File.join("public", "logs", "#{Time.now.to_date}")
    FileUtils.makedirs(logs_folder) unless File.exist?(logs_folder)
    filename = "用户开户数据"

    write_rows.uniq!

    file = Axlsx::Package.new
    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["手机号", "开户时间"]

      write_rows.each do |row|
        sheet.add_row(row, :types => [:string, :string])
      end

      file.use_shared_strings = true  
      file.serialize("#{logs_folder}/#{filename}.xlsx")
    end

    return "#{logs_folder}/#{filename}.xlsx", write_rows.size
  end

  # 姓名  手机  身份证   积分  小金   兑换时间（年月日）   唯一ID  失败原因
  # LogProcess.generate_member_log
  def self.generate_member_log
    write_rows = []
    member_card_point_logs = MemberCardPointLog.where(created_at: 1.day.ago..DateTime.now)
    member_card_point_logs.each do |log|
      customer = log.try(:customer)

      next unless customer.present?

      name = customer.try(:customer_reg_info).try(:name)
      phone = customer.try(:user).try(:phone)
      id_card = customer.try(:customer_reg_info).try(:id_card)
      jajin = customer.try(:jajin).try(:got)
      trade_time = log.try(:created_at).strftime("%Y%m%d")
      unique_ind = log.try(:unique_ind)

      write_rows << [name, phone, id_card, jajin, trade_time, unique_ind]
    end

    path = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "#{DateTime.now.strftime("%Y%m%d")}-success"
    head = ["姓名", "手机", "身份证", "积分(小金)", "兑换时间", "唯一ID"]
    head_format = [:string, :string, :string, :string, :string, :string]
    write_rows.uniq!
    write_file path, filename, head, head_format, write_rows

    return "#{path}/#{filename}.xlsx", write_rows.size
  end

  # LogProcess.generate_point_log_errors
  def self.generate_point_log_errors
    write_rows = []
    error_infos = PointLogFailureInfo.where(created_at: 1.day.ago..DateTime.now)
    error_infos.each do |log|

      trade_time = log.try(:created_at).strftime("%Y%m%d")

      case log.error_code.to_i
      when 10001 
        reason = "签名验证失败"
      when 10002
        reason = "数据缺失"
      when 10003
        reason = "注册失败"
      when 10004
        reason = "身份信息错误"
      when 10005
        reason = "用户实名制认证失败"
      when 10006
        reason = "用户实名制认证失败"
      when 10007
        reason = "唯一标示已经存在"
      when 10008
        reason = "积分记录创建失败"
      when 10009
        reason = "用户已存在"
      end
      write_rows << [log.name, log.phone, log.id_card, log.point, trade_time, log.unique_ind, reason]
    end

    path = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "#{DateTime.now.strftime("%Y%m%d")}-failure"
    head = ["姓名", "手机", "身份证", "积分(小金)", "兑换时间", "唯一ID", "错误原因"]
    head_format = [:string, :string, :string, :string, :string, :string, :string]
    write_rows.uniq!
    write_file path, filename, head, head_format, write_rows
    return "#{path}/#{filename}.xlsx", write_rows.size
  end

  def self.write_file path, filename, head, head_format, content
    puts content.class
    FileUtils.makedirs(path) unless File.exist?(path)
    
    file = Axlsx::Package.new
    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row head

      if content.present?
        content.each do |row|
          sheet.add_row(row, :types => head_format)
        end
      end

      file.use_shared_strings = true  
      file.serialize("#{path}/#{filename}.xlsx")
    end
  end

  # LogProcess
  def self.get_jajin
    write_rows = []
    path = File.join("public", "success.xls")
    data = Spreadsheet.open path
    sheet = data.worksheet 0
    sheet.each do |row|
      user = User.find_by(phone: row[0].to_s)
      next unless user.present?
      jajin = user.try(:customer).try(:jajin).try(:got)
      row << jajin
      write_rows << row
    end

    path1 = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "用户小金"
    head = ["手机", "姓名", "身份证", "性别", "小金"]
    head_format = [:string, :string, :string, :string, :string]
    write_rows.uniq!
    write_file path1, filename, head, head_format, write_rows
    return "#{path}/#{filename}.xlsx", write_rows.size
  end

  def self.get_custoemr_info
    write_rows = []
    users = User.where(created_at: 1.week.ago..DateTime.now)

    users_size = users.size
    verify_num = 0
    pension_num = 0
    users.each do |user|
      if user.try(:customer).try(:customer_reg_info).try(:verify_state) == "verified"
        verify_num += 1
      end
      got = user.try(:customer).try(:jajin).try(:got)
      pension_num += got if got.present?
    end

    activity_user_size = users.where(user_source: 2).size

    source_ids = users.group(:source_id).pluck(:source_id)
    source_ids.delete 3

    hash = {}
    source_ids.each do |source_id|
      agent = Agent.find_by(id: source_id)
      hash[agent.name] = users.where(source_id: source_id).size
    end

    head = ["总新增用户", "实名认证用户", "养老金总数量", "活动新增用户"]+hash.keys
    row = [users_size, verify_num, ((pension_num.to_f)/100).to_s, activity_user_size]+hash.values
    write_rows = []
    write_rows << row


    path = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "用户数据统计"
    head_format = [:string, :string, :string, :string]+[:string]*hash.size

    write_file path, filename, head, head_format, write_rows
    return "#{path}/#{filename}.xlsx"
  end
end
