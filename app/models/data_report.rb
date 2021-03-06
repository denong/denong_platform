# == Schema Information
#
# Table name: data_reports
#
#  id              :integer          not null, primary key
#  report_date     :datetime
#  u_day_count     :float(24)        default(0.0)
#  u_month_count   :float(24)        default(0.0)
#  u_sum           :float(24)        default(0.0)
#  ul_day_count    :float(24)
#  ul_month_count  :float(24)
#  ul_sum          :float(24)
#  j_day_count     :float(24)        default(0.0)
#  j_month_count   :float(24)        default(0.0)
#  j_sum           :float(24)        default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  u_ios_count     :float(24)        default(0.0)
#  u_android_count :float(24)        default(0.0)
#  u_other_count   :float(24)        default(0.0)
#

class DataReport < ActiveRecord::Base
  def process
    p "----------------------------------------------DataReport Start--------------------------------------------------"
    sleep 100
    p "----------------------------------------------DataReport End---------------------------------------------------"

    # UserReport.new.process
    # FinanceReport.new.process
  end

  class JajinReport
    def process
      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "财务报表") do |sheet|
        sheet.add_row ["小金记录"]
        sheet.add_row ["统计时间", "商户名", "代理商", "比例", "小金", "交易金额"]

        prices = JajinLog.sum_amount
        prices.map do |i, e|
          merchant = Merchant.where(id: i).first
          if merchant.present?
            merchant_info = MerchantSysRegInfo.where(merchant_id: merchant.id).first.sys_name
            agent_name = merchant.agent.name rescue ""
            sheet.add_row [Time.now.strftime("%Y-%m-%d %H:%M"), merchant_info, agent_name, merchant.ratio, e, TlTrade.where(merchant_id: i).sum(:price)]
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

        prices = TlTrade.day_price_merchant
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
        prices = TlTrade.month_price_merchant
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

  class TlTradeStatis
    def process(start_time, end_time)
      datetime = Time.now.strftime("%Y-%m-%d")
      file = File.open("public/tl_#{datetime}.txt", "w")
      datas = TlTrade.where("created_at > ? and created_at < ?", start_time, end_time)
      datas.each do |t|
        customer = t.try(:customer)
        file.write("#{t.try(:phone)},#{customer.try(:customer_reg_info).try(:id_card)},#{t.try(:price)},#{t.try(:merchant).try(:sys_reg_info).try(:sys_name)},#{t.try(:shop_ind)}#{t.try(:pos_machine_id)},#{t.try(:trade_time)},\r\n")
      end
      file.close
    end
  end

  class TlTradeStatisDetail
    def process
      datetime = Time.now.strftime("%Y-%m-%d")
      file = File.open("public/tl_detail_#{datetime}.txt", "w")
      datas = TlTrade.all
      datas.each do |t|
        customer_reg_info = t.try(:customer).try(:customer_reg_info)
        file.write(t.try(:phone))
        file.write(",")
        file.write(customer_reg_info.try(:name))
        file.write(",")
        file.write(customer_reg_info.try(:id_card))
        file.write(",")
        file.write(t.trade_time)
        file.write(",")
        file.write(t.price)
        file.write(",")
        file.write(t.try(:merchant).try(:ratio))
        file.write(",")
        file.write(t.try(:merchant).try(:sys_reg_info).try(:sys_name))
        file.write(",")
        file.write(t.try(:jajin_log).try(:amount))
        file.write("\r\n")
      end
      file.close
    end
  end
end
