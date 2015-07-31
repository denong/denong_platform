# == Schema Information
#
# Table name: data_reports
#
#  id              :integer          not null, primary key
#  report_date     :datetime
#  u_day_count     :float            default(0.0)
#  u_month_count   :float            default(0.0)
#  u_sum           :float            default(0.0)
#  ul_day_count    :float
#  ul_month_count  :float
#  ul_sum          :float
#  j_day_count     :float            default(0.0)
#  j_month_count   :float            default(0.0)
#  j_sum           :float            default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  u_ios_count     :float            default(0.0)
#  u_android_count :float            default(0.0)
#  u_other_count   :float            default(0.0)
#

class DataReport < ActiveRecord::Base
  def process
    UserReport.new.process
    FinanceReport.new.process
  end

  class JajinReport
    def process
      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "财务报表") do |sheet|
        sheet.add_row ["小金记录"]
        sheet.add_row ["统计时间", "商户名", "代理商", "比例", "小金"]

        prices = JajinLog.sum_amount
        prices.map do |i, e|
          merchant = Merchant.where(id: i).first
          if merchant.present?
            merchant_info = MerchantSysRegInfo.where(merchant_id: merchant.id).first.sys_name
            sheet.add_row [Time.now.strftime("%Y-%m-%d %H:%M"), merchant_info, merchant.agent.name, merchant.ratio, e]
          end
        end
        p.use_shared_strings = true
        p.serialize("public/jajin_#{Time.zone.now.strftime('%Y-%m-%d')}.xlsx")
      end
    end
  end

  class FinanceReport
    def process
      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "财务报表") do |sheet|
        sheet.add_row ["日报表"]
        sheet.add_row ["统计时间", "商户名", "代理商", "交易金额", "小金"]

        prices = TlTrade.sum_day_price
        prices.map do |i, e|
          merchant = Merchant.where(id: i).first
          if merchant.present?
            merchant.jajin_total
            merchant_info = MerchantSysRegInfo.where(merchant_id: merchant.id).first.sys_name
            sheet.add_row [Time.now.strftime("%Y-%m-%d %H:%M"), merchant_info, merchant.agent.name, e, merchant.jajin_total]
          end
        end

        sheet.add_row ["月报表"]
        sheet.add_row ["统计时间", "商户名", "代理商", "交易金额", "小金"]
        prices = TlTrade.sum_month_price
        prices.map do |i, e|
          merchant = Merchant.where(id: i).first
          if merchant.present?
            merchant.jajin_total
            merchant_info = MerchantSysRegInfo.where(merchant_id: merchant.id).first.sys_name
            sheet.add_row [Time.now.strftime("%Y-%m-%d %H:%M"), merchant_info, merchant.agent.name, e, merchant.jajin_total]
          end
        end
      end
      p.use_shared_strings = true
      p.serialize("public/#{Time.zone.now.strftime('%Y-%m-%d')}.xlsx")
    end
  end

  class UserReport

    def process
      data_reports = DataReport.find_or_create_by(report_date: (Time.now.to_date - 1.day) + 8.hours)
      data_reports.u_day_count = User.today.count
      data_reports.u_month_count = User.month.count
      data_reports.u_sum = User.all.count
      data_reports.u_ios_count = User.ios_count.count
      data_reports.u_android_count = User.android_count.count
      data_reports.u_other_count = User.all.count - (data_reports.u_ios_count + data_reports.u_android_count)
      data_reports.ul_day_count = User.today_sign_in.count
      data_reports.ul_month_count = User.month_sign_in.count
      data_reports.ul_sum = User.all_sign_in.count
      data_reports.j_day_count = JajinLog.today.inject(0){|sum, item| sum += item.amount }
      data_reports.j_month_count = JajinLog.month.inject(0){|sum, item| sum += item.amount }
      data_reports.j_sum = JajinLog.all.inject(0){|sum, item| sum += item.amount }
      data_reports.save
    end
  end
end
