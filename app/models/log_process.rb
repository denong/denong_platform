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

 

  # LogProcess.get_jajin
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
    return "#{path1}/#{filename}.xlsx", write_rows.size
  end

  def get_customer_info start_time, end_time
    write_rows = []
    users = User.where(created_at: start_time.to_date..end_time.to_date)

    users_size = users.size

    pension_num, verify_num = LogProcess.get_pi_count users

    activity_user_size = users.where(user_source: 2).size

    source_ids = users.group(:source_id).pluck(:source_id)
    source_ids.delete 3

    hash = {}
    source_ids.each do |source_id|
      agent = Agent.find_by(id: source_id)
      source_user = users.where(source_id: source_id)
      hash["#{agent.name}新增用户"] = source_user.size
      source_pension, source_verify = get_pi_count source_user
      hash["#{agent.name}养老金总数量"] = source_pension
      hash["#{agent.name}实名认证用户"] = source_verify
    end

    head = ["总新增用户", "实名认证用户", "养老金总数量", "活动新增用户"]+hash.keys
    row = [users_size, verify_num, pension_num, activity_user_size]+hash.values
    write_rows = []
    write_rows << row


    path = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "#{Time.now.strftime("%Y%m%d")}用户数据统计"
    head_format = [:string, :string, :string, :string]+[:string]*hash.size

    write_file path, filename, head, head_format, write_rows
    return "#{path}/#{filename}.xlsx"
  end

  def self.get_pi_count users
    verify_num = 0
    pension_num = 0

    users.each do |user|
      if user.try(:customer).try(:customer_reg_info).try(:verify_state) == "verified"
        verify_num += 1
      end
      got = user.try(:customer).try(:jajin).try(:got)
      pension_num += got if got.present?
    end

    return ((pension_num.to_f)/100).to_s, verify_num
  end
  # LogProcess.jajin_process
  def jajin_process
      
    write_rows = []

    # 获取到所有有错误的用户
    customer_ids = []
    Customer.all.each do |c|
      jt = c.try(:jajin).try(:got)
      next unless jt.present?
      jls = c.try(:jajin_logs)
      next unless jls.present?

      jl = jls.sum(:amount)
      if jl!=jt
        
        member_card_logs = c.try(:member_card_point_logs)
        reward_logs = c.try(:reward_logs)
        ticket_logs = c.try(:ticket)
        jajin_verify_logs = c.try(:jajin_verify_logs)
        exchange_logs = c.try(:exchange_logs)
        tl_trades = c.try(:tl_trades)


        # 手机号、姓名、
        phone = c.try(:user).try(:phone)
        name = c.try(:customer_reg_info).try(:name)

        # jajin_logs.num、积分记录、奖励记录、小票、验证码、exchange、通联、
        jajin_log_num =jls.try(:size)
        member_card_point_log_num = member_card_logs.try(:size)
        reward_log_num = reward_logs.try(:size)
        ticket_log_num = ticket_logs.try(:size)
        jajin_verify_log_num = jajin_verify_logs.try(:size)
        exchange_log_num = exchange_logs.try(:size)
        tl_trade_num = tl_trades.try(:size)

        # 积分记录小金、奖励记录小金、小票小金、验证码小金、exchange小金、通联小金
        member_card_log_sum = member_card_logs.try(:sum, :jajin)
        reward_log_sum = reward_logs.try(:sum, :amount)
        ticket_sum = 0
        jajin_verify_log_sum = jajin_verify_logs.try(:sum, :amount)
        exchange_log_sum = exchange_logs.try(:sum, :amount)
        # tl_trade_sum = tl_trades.sum((:price * 100 * ratio).ceil)
        tl_trade_sum = 0
        if tl_trades.present?
          tl_trades.each do |tl_trade|
            tl_trade_sum += (tl_trade.price * 100 * (tl_trade.try(:merchant).try(:ratio)||0.01)).ceil
          end
        end
        # 手机号、姓名、  积分记录、      奖励记录、        小票、           验证码、               exchange、         通联、         got小金数、记录小金总数、积分记录小金、奖励记录小金、小票小金、验证码小金、exchange小金、通联小金
        write_rows << [ phone, name, jajin_log_num, reward_log_num, ticket_log_num, jajin_verify_log_num, exchange_log_num, tl_trade_num, jt, jl, member_card_log_sum, reward_log_sum, ticket_sum, jajin_verify_log_sum, exchange_log_sum, tl_trade_sum]
      end
    end

    path1 = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "错误数据"
    head = ["手机号", "姓名", "小金记录总数", "积分记录", "奖励记录", "小票", "验证码", "exchange", "通联", "got小金数", "记录小金总数", "积分记录小金", "奖励记录小金", "小票小金", "验证码小金", "exchange小金", "通联小金"]
    head_format = [:string]*17
    write_rows.uniq!
    write_file path1, filename, head, head_format, write_rows
    # 手机号、姓名、jajin_logs.num、积分记录、奖励记录、小票、验证码、exchange、通联、小金总数、积分记录小金、奖励记录小金、小票小金、验证码小金、exchange小金、通联小金
    return "#{path1}/#{filename}.xlsx"
  end

  def self.gdtelecom_info start_time, end_time
    write_rows = []
    time = start_time
    last_num = 0
    all_array = []
    while time < end_time
      logs = MemberCardPointLog.where(created_at: time..time+1.day)
      customer_arrays = logs.group(:customer_id).pluck(:customer_id)
      all_array.concat customer_arrays
      all_array.uniq!
      user_num = all_array.size - last_num
      last_num += user_num
      jajin_num = logs.sum(:jajin)
      write_rows << [time.strftime("%Y%m%d"), user_num, jajin_num]
      time += 1.day
    end
    path1 = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "兑换数据"
    head = ["时间", "兑换人数", "积分总数"]
    head_format = [:string]*3
    write_rows.uniq!
    write_file path1, filename, head, head_format, write_rows

    return "#{path1}/#{filename}.xlsx"
  end

  def get_customer_info_by_merchant
    source_ids = User.group(:source_id).pluck(:source_id)

    info = {}
    source_ids.each do |source_id|
      sys_name = Merchant.find_by(id: source_id).try(:sys_reg_info).try(:sys_name)
      info[sys_name] = {}

      (5..10).each do |index|
        info[sys_name][index] = {}
        start_time, end_time = DateTime.new(2015,index,1), DateTime.new(2015,index+1,1)
        users = User.where(source_id: source_id, created_at: start_time..end_time)
        info[sys_name][index]["user_num"] = users.size

        real_user = 0
        real_user_jajin = 0
        user_jajin = 0
        users.each do |user|
          customer = user.try(:customer)
          next unless customer.present?
          customer_reg_info = customer.try(:customer_reg_info)
          next unless customer_reg_info.present?
          if customer_reg_info.verify_state == "verified"
            real_user += 1 
            real_user_jajin += (customer.try(:jajin).try(:got) || 0)
          end
          user_jajin += (customer.try(:jajin).try(:got) || 0)
        end
        info[sys_name][index]["real_user"] = real_user
        info[sys_name][index]["real_user"] = real_user
        info[sys_name][index]["real_user_jajin"] = real_user_jajin
        info[sys_name][index]["user_jajin"] = user_jajin
      end
    end

    write_rows = []
    info.each_with_index do |data, index|
      info_hash = data.last
      info_hash.each do |month, info|
        write_rows << [index+1, month, data.first, info["user_num"], info["user_jajin"], info["real_user"], info["real_user_jajin"]]
      end
    end
    path1 = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "用户统计数据区分渠道"
    head = ["编号", "商户名称", "用户总数", "用户小金数", "实名制用户数", "实名制用户小金"]
    head_format = [:string]*6
    write_rows.uniq!
    write_file path1, filename, head, head_format, write_rows
  end

  # 姓名  手机  身份证   积分  小金   兑换时间（年月日）   唯一ID
  # LogProcess.generate_telecom_user
  def self.generate_telecom_user
    write_rows = []
    telecom_users = TelecomUser.where(created_at: 1.day.ago..DateTime.now)
    telecom_users.each do |telecom_user|
      name = telecom_user.try(:name)
      phone = telecom_user.try(:phone)
      id_card = telecom_user.try(:id_card)
      point = telecom_user.try(:point)
      trade_time = telecom_user.try(:created_at).strftime("%Y%m%d%H%M%S")
      unique_ind = telecom_user.try(:unique_ind)

      write_rows << [name, phone, id_card, point, trade_time, unique_ind]
    end

    path = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "#{DateTime.now.strftime("%Y%m%d")}-telecom"
    head = ["姓名", "手机", "身份证", "积分(小金)", "兑换时间", "唯一ID"]
    head_format = [:string, :string, :string, :string, :string, :string]
    write_rows.uniq!
    write_file path, filename, head, head_format, write_rows

    return "#{path}/#{filename}.xlsx", write_rows.size
  end

  def self.point_logs_sum 
    write_rows = []
    (8..22).each do |day|
      logs_5 = MemberCardPointLog.where(created_at: DateTime.new(2015,10,day,0,5)..DateTime.new(2015,10,day+1,0,5), jajin: 500)
      logs_10 = MemberCardPointLog.where(created_at: DateTime.new(2015,10,day,0,5)..DateTime.new(2015,10,day+1,0,5), jajin: 1000)


      write_rows << [day.to_s, logs_5.size+logs_10.size, logs_5.sum(:jajin)+logs_10.sum(:jajin), logs_5.size, logs_5.sum(:jajin), logs_10.size, logs_10.sum(:jajin)]
    end

    path = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    filename = "#{DateTime.now.strftime("%Y%m%d")}-everyday-sum"
    head = ["时间", "总条数", "总积分数", "5元条数", "5元积分总数", "10元条数", "10元积分总数"]
    head_format = [:string, :string, :string, :string, :string, :string]
    write_rows.uniq!
    write_file path, filename, head, head_format, write_rows
  end

  def self.generate_user_info
    filename = "#{DateTime.now.strftime("%Y%m%d")}-user.xlsx"
    path = File.join("public", "logs", "#{Time.now.strftime("%Y%m%d")}")
    FileUtils.makedirs(path) unless File.exist?(path)
    file = Axlsx::Package.new

    file.workbook.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["手机号", "来源", "姓名", "身份证", "小金", "注册时间"]

      users = User.where(created_at: 1.day.ago..DateTime.now)
      users.each_with_index do |user, index|
        phone = user.try(:phone)
        user_source = user.try(:source_id)
        name = user.try(:customer).try(:customer_reg_info).try(:name)
        id_card = user.try(:customer).try(:customer_reg_info).try(:id_card)
        jajin = user.try(:customer).try(:jajin).try(:got)
        created_time = user.try(:created_at).strftime("%Y%m%d%H%M%S")

        sheet.add_row([phone, user_source, name, id_card, jajin, created_time], :types => [:string, :string, :string, :string, :string, :string])
      end
      file.use_shared_strings = true  
      file.serialize("#{path}/#{filename}")
    end
    return "#{path}/#{filename}"#, users.size
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
      jajin = log.try(:jajin)
      trade_time = log.try(:created_at).strftime("%Y%m%d%H%M%S")
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

      trade_time = log.try(:created_at).strftime("%Y%m%d%H%M%S")

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
end
