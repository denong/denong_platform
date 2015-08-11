# == Schema Information
#
# Table name: merchant_logs
#
#  id            :integer          not null, primary key
#  datetime      :datetime
#  data_type     :string(255)
#  name          :string(255)
#  d_jajin_count :float
#  w_jajin_count :float
#  m_jajin_count :float
#  all_jajin     :float
#  d_user_count  :integer
#  w_user_count  :integer
#  m_user_count  :integer
#  all_user      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class MerchantLog < ActiveRecord::Base

  def process
    now_day = Time.zone.now
    merchants = Merchant.all
    merchants.each do |item|
      merchant_log = MerchantLog.find_or_create_by(datetime: (now_day.to_date - 1.day) + 8.hours, name: item.sys_reg_info.sys_name, data_type: "商户")
      merchant_log.d_jajin_count = item.jajin_logs.today.sum(:amount)
      merchant_log.w_jajin_count = item.jajin_logs.week.sum(:amount)
      merchant_log.m_jajin_count = item.jajin_logs.month.sum(:amount)
      merchant_log.all_jajin = item.jajin_logs.all.sum(:amount)

      merchant_log.d_user_count = item.member_cards.today.count
      merchant_log.w_user_count = item.member_cards.week.count
      merchant_log.m_user_count = item.member_cards.month.count
      merchant_log.all_user = item.member_cards.count
      merchant_log.save
    end

    agents = Agent.all
    agents.each do |item|
      merchant_log = MerchantLog.find_or_create_by(datetime: (now_day.to_date - 1.day) + 8.hours, name: item.name, data_type: "代理商")
      merchant_log.d_jajin_count = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.today.sum(:amount) }
      merchant_log.w_jajin_count = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.week.sum(:amount) }
      merchant_log.m_jajin_count = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.month.sum(:amount) }
      merchant_log.all_jajin = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.sum(:amount) }

      merchant_log.d_user_count = item.merchants.inject(0) { |sum, item| sum + item.member_cards.today.count }
      merchant_log.w_user_count = item.merchants.inject(0) { |sum, item| sum + item.member_cards.week.count }
      merchant_log.m_user_count = item.merchants.inject(0) { |sum, item| sum + item.member_cards.month.count }
      merchant_log.all_user = item.merchants.inject(0) { |sum, item| sum + item.member_cards.count }
      merchant_log.save
    end
  end
end
