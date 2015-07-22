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