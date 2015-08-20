# == Schema Information
#
# Table name: merchant_logs
#
#  id                 :integer          not null, primary key
#  datetime           :datetime
#  data_type          :string(255)
#  name               :string(255)
#  d_jajin_count      :float
#  w_jajin_count      :float
#  m_jajin_count      :float
#  all_jajin          :float
#  d_user_count       :integer
#  w_user_count       :integer
#  m_user_count       :integer
#  all_user           :integer
#  created_at         :datetime
#  updated_at         :datetime
#  d_price            :integer          default(0)
#  w_price            :integer          default(0)
#  m_price            :integer          default(0)
#  all_price          :integer          default(0)
#  d_point_sum        :float
#  m_point_sum        :float
#  w_point_sum        :float
#  d_pension_sum      :float
#  m_pension_sum      :float
#  w_pension_sum      :float
#  d_point_user_count :integer
#  w_point_user_count :integer
#  m_point_user_count :integer
#

class MerchantLog < ActiveRecord::Base

  def process
    now_day = Time.zone.now
    # 商户
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

      merchant_log.d_price = item.tl_trades.sum_day_price
      merchant_log.w_price = item.tl_trades.sum_week_price
      merchant_log.m_price = item.tl_trades.sum_month_price
      merchant_log.all_price = item.tl_trades.all_price
      
      # merchant_log.d_price = 0
      # merchant_log.w_price = 0
      # merchant_log.m_price = 0
      # merchant_log.all_price = 0

      merchant_log.d_point_sum = 0
      merchant_log.m_point_sum = 0
      merchant_log.w_point_sum = 0

      merchant_member_cards = item.member_cards.all

      member_card_logs = []
      merchant_member_cards.each do |member_card|
        member_card_logs << member_card.member_card_point_logs
      end

      member_card_logs.today.each { |log| merchant_log.d_point_sum += log.jajin } if member_card_logs.today.present?
      member_card_logs.week.each { |log| merchant_log.w_point_sum += log.jajin } if member_card_logs.week.present?
      member_card_logs.month.each { |log| merchant_log.m_point_sum += log.jajin } if member_card_logs.month.present?

      merchant_log.d_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.day).group(:customer_id).pluck(:customer_id).size
      merchant_log.w_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.week).group(:customer_id).pluck(:id,:customer_id).size
      merchant_log.m_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.month).group(:customer_id).pluck(:id,:customer_id).size

      merchant_log.d_pension_sum = merchant_log.d_point_sum/100
      merchant_log.m_pension_sum = merchant_log.m_point_sum/100
      merchant_log.w_pension_sum = merchant_log.w_point_sum/100
      
      merchant_log.save
    end

    # 代理商
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

      merchant_log.d_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.today.count }
      merchant_log.w_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.week.count }
      merchant_log.m_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.month.count }
      merchant_log.all_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.count }
      merchant_log.save
    end
  end
end
