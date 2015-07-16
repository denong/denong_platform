class DataReport
  
  def process
    UserReport.new.process
  end

  class UserReport

    def process
      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(:name => "日统计报表") do |sheet|
          sheet.add_row ["用户增涨表"]
          
          sheet.add_row ["","增涨量"]
          %w(昨天 7天 30天).each do |label| 
            case label
            when '昨天'
              sheet.add_row [label, User.today.count] 
            when '7天'
              sheet.add_row [label, User.weeks.count] 
            when '30天'
              sheet.add_row [label, User.month.count] 
            end
          end
          
          sheet.add_row ["小金增涨表"]
          sheet.add_row ["","增涨量"]
          %w(昨天 7天 30天).each do |label| 
            case label
            when '昨天'
              sheet.add_row [label, JajinLog.today.sum(:amount)] 
            when '7天'
              sheet.add_row [label, JajinLog.weeks.sum(:amount)] 
            when '30天'
              sheet.add_row [label, JajinLog.month.sum(:amount)] 
            end
          end

        end
        FileUtils.mkdir("./public/report/") unless File.exist?("./public/report/")
        date = (Time.zone.now.to_date - 1.day).strftime("%Y-%m-%d")
        p.serialize("./public/report/#{date}.xlsx")
      end
      nil
    end
  end

end