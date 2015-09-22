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
        sheet.add_row([result["手机号"], result["身份证号"], result["姓名"], result["交易标示"], result["兑换积分"], result["错误原因"]], :types => [:string, :string, :string, :string, :string, :string])
      end
      
      file.use_shared_strings = true
      file.serialize("#{logs_folder}/#{key}.xlsx")
    end
    "#{logs_folder}/#{key}.xlsx"
  end
end
