# == Schema Information
#
# Table name: merchant_logs
#
#  id                 :integer          not null, primary key
#  datetime           :datetime
#  data_type          :string(255)
#  name               :string(255)
#  d_jajin_count      :float(24)
#  w_jajin_count      :float(24)
#  m_jajin_count      :float(24)
#  all_jajin          :float(24)
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
#  d_point_sum        :float(24)
#  m_point_sum        :float(24)
#  w_point_sum        :float(24)
#  d_pension_sum      :float(24)
#  m_pension_sum      :float(24)
#  w_pension_sum      :float(24)
#  d_point_user_count :integer
#  w_point_user_count :integer
#  m_point_user_count :integer
#

class MerchantLog < ActiveRecord::Base

  def self.supply
    now_day = Time.new(2015,9,7)
    (0..11).each do |i|
      puts "#{i}"
      MerchantLog.new.process2 now_day - i.day, 162
    end
  end

  def process2 now_day, merchant_id = 0, agent_id = 0
    # 商户
    merchant = Merchant.find_by(id: merchant_id)
    if merchant.present?
      merchant_log = MerchantLog.find_or_create_by(datetime: (now_day.to_date - 1.day), name: merchant.sys_reg_info.try(:sys_name), data_type: "商户")
      merchant_log.d_jajin_count = merchant.jajin_logs.today(now_day).sum(:amount)
      merchant_log.w_jajin_count = merchant.jajin_logs.week(now_day).sum(:amount)
      merchant_log.m_jajin_count = merchant.jajin_logs.month(now_day).sum(:amount)
      merchant_log.all_jajin = merchant.jajin_logs.all.sum(:amount)

      merchant_log.d_user_count = merchant.member_cards.today(now_day).count
      merchant_log.w_user_count = merchant.member_cards.week(now_day).count
      merchant_log.m_user_count = merchant.member_cards.month(now_day).count
      merchant_log.all_user = merchant.member_cards.count

      merchant_log.d_price = merchant.tl_trades.sum_day_price
      merchant_log.w_price = merchant.tl_trades.sum_week_price
      merchant_log.m_price = merchant.tl_trades.sum_month_price
      merchant_log.all_price = merchant.tl_trades.all_price
      
      # merchant_log.d_price = 0
      # merchant_log.w_price = 0
      # merchant_log.m_price = 0
      # merchant_log.all_price = 0

      merchant_log.d_point_sum = 0
      merchant_log.m_point_sum = 0
      merchant_log.w_point_sum = 0

      # merchant_member_cards = merchant.member_cards.all

      # d_member_card_logs = []
      # w_member_card_logs = []
      # m_member_card_logs = []

      # merchant_member_cards.each do |member_card|
      #   member_card.member_card_point_logs.today.each { |log| d_member_card_logs << log }
      #   member_card.member_card_point_logs.week.each { |log| w_member_card_logs << log }
      #   member_card.member_card_point_logs.month.each { |log| m_member_card_logs << log }
      # end

      # d_member_card_logs.each { |log| merchant_log.d_point_sum += log.jajin } unless d_member_card_logs.empty?
      # w_member_card_logs.each { |log| merchant_log.w_point_sum += log.jajin } unless w_member_card_logs.empty?
      # m_member_card_logs.each { |log| merchant_log.m_point_sum += log.jajin } unless m_member_card_logs.empty?

      merchant_log.d_point_sum = merchant.member_cards.inject(0) { |sum, m| sum += m.member_card_point_logs.today(now_day).inject(0) { |sum,l| sum += l.jajin } }
      merchant_log.w_point_sum = merchant.member_cards.inject(0) { |sum, m| sum += m.member_card_point_logs.week(now_day).inject(0) { |sum,l| sum += l.jajin } }
      merchant_log.m_point_sum = merchant.member_cards.inject(0) { |sum, m| sum += m.member_card_point_logs.month(now_day).inject(0) { |sum,l| sum += l.jajin } }

      merchant_log.d_point_user_count = merchant.member_cards.inject(0) { |sum, member_card| sum + member_card.member_card_point_logs.today(now_day).group(:customer_id).pluck(:customer_id).size }
      merchant_log.w_point_user_count = merchant.member_cards.inject(0) { |sum, member_card| sum + member_card.member_card_point_logs.week(now_day).group(:customer_id).pluck(:customer_id).size }
      merchant_log.m_point_user_count = merchant.member_cards.inject(0) { |sum, member_card| sum + member_card.member_card_point_logs.month(now_day).group(:customer_id).pluck(:customer_id).size }

      # merchant_log.d_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.day).group(:customer_id).pluck(:customer_id).size
      # merchant_log.w_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.week).group(:customer_id).pluck(:customer_id).size
      # merchant_log.m_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.month).group(:customer_id).pluck(:customer_id).size
     
      merchant_log.d_pension_sum = merchant_log.d_point_sum/100
      merchant_log.m_pension_sum = merchant_log.m_point_sum/100
      merchant_log.w_pension_sum = merchant_log.w_point_sum/100
      
      merchant_log.save
    end

    # 代理商
    agent = Agent.find_by(id: agent_id)
    if agent.present?
      merchant_log = MerchantLog.find_or_create_by(datetime: (now_day.to_date - 1.day) + 8.hours, name: item.name, data_type: "代理商")
      merchant_log.d_jajin_count = agent.merchants.inject(0) { |sum, agent| sum + agent.jajin_logs.today(now_day).sum(:amount) }
      merchant_log.w_jajin_count = agent.merchants.inject(0) { |sum, agent| sum + agent.jajin_logs.week(now_day).sum(:amount) }
      merchant_log.m_jajin_count = agent.merchants.inject(0) { |sum, agent| sum + agent.jajin_logs.month(now_day).sum(:amount) }
      merchant_log.all_jajin = agent.merchants.inject(0) { |sum, agent| sum + agent.jajin_logs.sum(:amount) }

      merchant_log.d_user_count = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.today(now_day).count }
      merchant_log.w_user_count = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.week(now_day).count }
      merchant_log.m_user_count = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.month(now_day).count }
      merchant_log.all_user = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.count }

      merchant_log.d_price = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.today(now_day).count }
      merchant_log.w_price = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.week(now_day).count }
      merchant_log.m_price = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.month(now_day).count }
      merchant_log.all_price = agent.merchants.inject(0) { |sum, agent| sum + agent.member_cards.count }
      merchant_log.save
    end
  end

  def process
    now_day = Time.zone.now
    # 商户
    merchants = Merchant.all
    merchants.each do |item|
      merchant_log = MerchantLog.find_or_create_by(datetime: (now_day.to_date - 1.day) + 8.hours, name: item.sys_reg_info.sys_name, data_type: "商户")
      merchant_log.d_jajin_count = item.jajin_logs.today(now_day).sum(:amount)
      merchant_log.w_jajin_count = item.jajin_logs.week(now_day).sum(:amount)
      merchant_log.m_jajin_count = item.jajin_logs.month(now_day).sum(:amount)
      merchant_log.all_jajin = item.jajin_logs.all.sum(:amount)

      merchant_log.d_user_count = item.member_cards.today(now_day).count
      merchant_log.w_user_count = item.member_cards.week(now_day).count
      merchant_log.m_user_count = item.member_cards.month(now_day).count
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

      # merchant_member_cards = item.member_cards.all

      # d_member_card_logs = []
      # w_member_card_logs = []
      # m_member_card_logs = []

      # merchant_member_cards.each do |member_card|
      #   member_card.member_card_point_logs.today.each { |log| d_member_card_logs << log }
      #   member_card.member_card_point_logs.week.each { |log| w_member_card_logs << log }
      #   member_card.member_card_point_logs.month.each { |log| m_member_card_logs << log }
      # end

      # d_member_card_logs.each { |log| merchant_log.d_point_sum += log.jajin } unless d_member_card_logs.empty?
      # w_member_card_logs.each { |log| merchant_log.w_point_sum += log.jajin } unless w_member_card_logs.empty?
      # m_member_card_logs.each { |log| merchant_log.m_point_sum += log.jajin } unless m_member_card_logs.empty?

      merchant_log.d_point_sum = item.member_cards.inject(0) { |sum, m| sum += m.member_card_point_logs.today(now_day).inject(0) { |sum,l| sum += l.jajin } }
      merchant_log.w_point_sum = item.member_cards.inject(0) { |sum, m| sum += m.member_card_point_logs.week(now_day).inject(0) { |sum,l| sum += l.jajin } }
      merchant_log.m_point_sum = item.member_cards.inject(0) { |sum, m| sum += m.member_card_point_logs.month(now_day).inject(0) { |sum,l| sum += l.jajin } }

      merchant_log.d_point_user_count = Merchant.find_by(id: item.id ).member_cards.inject(0) { |sum, member_card| sum + member_card.member_card_point_logs.today(now_day).group(:customer_id).pluck(:customer_id).size }
      merchant_log.w_point_user_count = Merchant.find_by(id: item.id ).member_cards.inject(0) { |sum, member_card| sum + member_card.member_card_point_logs.week(now_day).group(:customer_id).pluck(:customer_id).size }
      merchant_log.m_point_user_count = Merchant.find_by(id: item.id ).member_cards.inject(0) { |sum, member_card| sum + member_card.member_card_point_logs.month(now_day).group(:customer_id).pluck(:customer_id).size }

      # merchant_log.d_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.day).group(:customer_id).pluck(:customer_id).size
      # merchant_log.w_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.week).group(:customer_id).pluck(:customer_id).size
      # merchant_log.m_point_user_count = MemberCardPointLog.where("created_at > ?", Time.zone.now.to_date - 1.month).group(:customer_id).pluck(:customer_id).size
     
      merchant_log.d_pension_sum = merchant_log.d_point_sum/100
      merchant_log.m_pension_sum = merchant_log.m_point_sum/100
      merchant_log.w_pension_sum = merchant_log.w_point_sum/100
      
      merchant_log.save
    end

    # 代理商
    agents = Agent.all
    agents.each do |item|
      merchant_log = MerchantLog.find_or_create_by(datetime: (now_day.to_date - 1.day) + 8.hours, name: item.name, data_type: "代理商")
      merchant_log.d_jajin_count = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.today(now_day).sum(:amount) }
      merchant_log.w_jajin_count = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.week(now_day).sum(:amount) }
      merchant_log.m_jajin_count = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.month(now_day).sum(:amount) }
      merchant_log.all_jajin = item.merchants.inject(0) { |sum, item| sum + item.jajin_logs.sum(:amount) }

      merchant_log.d_user_count = item.merchants.inject(0) { |sum, item| sum + item.member_cards.today(now_day).count }
      merchant_log.w_user_count = item.merchants.inject(0) { |sum, item| sum + item.member_cards.week(now_day).count }
      merchant_log.m_user_count = item.merchants.inject(0) { |sum, item| sum + item.member_cards.month(now_day).count }
      merchant_log.all_user = item.merchants.inject(0) { |sum, item| sum + item.member_cards.count }

      merchant_log.d_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.today(now_day).count }
      merchant_log.w_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.week(now_day).count }
      merchant_log.m_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.month(now_day).count }
      merchant_log.all_price = item.merchants.inject(0) { |sum, item| sum + item.member_cards.count }
      merchant_log.save
    end
  end
end
