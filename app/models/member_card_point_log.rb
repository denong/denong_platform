# == Schema Information
#
# Table name: member_card_point_logs
#
#  id             :integer          not null, primary key
#  point          :float(24)
#  jajin          :float(24)
#  customer_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  member_card_id :integer
#  unique_ind     :string(255)
#

class MemberCardPointLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :member_card

  has_one :jajin_log, as: :jajinable

  after_create :calculate
  after_create :add_jajin_log

  validates_uniqueness_of :unique_ind#, if: "unique_ind.present?"
  validates_presence_of :customer, on: :create
  validates_presence_of :member_card, on: :create

  validate :must_point_negative, on: :create
  validate :must_have_jajin, on: :create
  validate :point_must_less_than_all_point, on: :create

  default_scope { order('id DESC') }

  scope :today, -> (datetime) { where('created_at between ? and ?', (datetime.to_date - 1.day).strftime("%Y-%m-%d 00:00:00"), datetime.to_date.strftime("%Y-%m-%d 00:00:00")) }
  scope :week, -> (datetime) { where('created_at between ? and ?', (datetime.to_date - 7.day).strftime("%Y-%m-%d 00:00:00"), datetime.to_date.strftime("%Y-%m-%d 00:00:00")) }
  scope :month, -> (datetime) { where('created_at between ? and ?', (datetime.to_date - 1.month).strftime("%Y-%m-%d 00:00:00"), datetime.to_date.strftime("%Y-%m-%d 00:00:00")) }

  def company
    "积分转小金"
  end

  def self.process_data_from_cache
    datas = $redis.hvals("process_data_cache")
    $redis.del("process_data_cache")
    # 校验是否注册
    # 
    # 校验用户是否实名制认证
    # 
    # 用户是否授权会员卡
    # 
    # 获得小金
    # 
    # 
  end

  def import(file)
    begin
      spreadsheet = MemberCardPointLog.open_spreadsheet(file)

      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |r|
      row = Hash[[header, spreadsheet.row(r)].transpose]
        # 存入缓存
        $redis.hset("process_data_cache", "#{row['交易的唯一标示']}", row)
      end
    rescue Exception => e
      p e
    end
  end

  def self.get_point_log_by_merchant merchant_id, params
    phone = params[:phone]
    member_cards = nil
    member_card_point_logs = []
    if phone.present?
      customer = User.find_by_phone(phone).try(:customer)
      if customer.present?
        member_cards = MemberCard.where(merchant_id: merchant_id, customer_id: customer.id)
      else
        return
      end
    else
      member_cards = MemberCard.where(merchant_id: merchant_id)
    end
    
    unless member_cards.present?
      return
    end

    if params[:begin_time].present? && params[:end_time].present?
      member_cards.each do |member_card|
        member_card.try(:member_card_point_logs).where(created_at: params[:begin_time]..params[:end_time]).each do |member_card_point_log|
          member_card_point_logs << member_card_point_log
        end
      end
    else
      member_cards.each do |member_card|
        member_card.try(:member_card_point_logs).each do |member_card_point_log|
          member_card_point_logs << member_card_point_log
        end
      end
    end
    member_card_point_logs
  end

  def self.get_point_log_by_agent agent_id, params
    agent = Agent.find_by_id(agent_id)
    point_logs = []
    agent.try(:merchants).each do |merchant|
      merchant_logs = get_point_log_by_merchant(merchant.id, params)
      next if merchant_logs.nil?
      merchant_logs.each do |point_log|
        point_logs << point_log
      end
    end
    point_logs
  end

  def self.open_spreadsheet(file)
    case File.extname(file)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "未知格式: #{file}"
    end
  end

  private

    def must_point_negative
      unless point < 0
        errors.add(:point, "必须小于0")
      end
    end

    def must_have_jajin
      if self.customer.try(:jajin).blank?
        errors.add(:message, "小确幸账号不存在")
      end
      self.jajin = point.abs
    end

    def point_must_less_than_all_point
      if self.member_card.point.nil?
        self.member_card.point = 0
        self.member_card.save
      end
      # unique_ind存在的话，就不用校验
      if unique_ind.present?
        return true
      end
      if self.member_card.point < point.to_f.abs
        errors.add(:point, "不能大于总积分数")
      end
    end

    def calculate
      jajin = self.customer.jajin
      jajin.got += point.abs
      jajin.save!

      member_card = self.member_card
      member_card.point += point
      member_card.total_trans_jajin += point.abs
      member_card.save!
    end

    def add_jajin_log
      member_card = MemberCard.find_by(id: member_card_id)
      merchant_id = member_card.merchant_id if member_card.present?
      self.create_jajin_log customer: customer, amount: jajin, merchant_id:merchant_id
    end

    def self.send_sms_notification params, first_time
      customer = Customer.find_by_id(params[:customer_id])
      user = customer.try(:user)
      unless user.present?
        return
      end

      phone = user.phone
      money = params[:point].abs.to_f/100

      tpl = 948587
      send_hash = {}
      if first_time
        # 刚完成注册之后，第一次兑换
        # 需发送金额、手机号、手机号后八位
        tpl = 948573
        send_hash[:money] = money
        send_hash[:phone] = phone
        send_hash[:secret] = phone[-8..-1]
      else
        # 非首次兑换
        # 需发送金额
        tpl = 948587
        send_hash[:money] = money
      end
      ChinaSMS.use :yunpian, password: "6eba427ea91dab9558f1c5e7077d0a3e"
      result = ChinaSMS.to user.phone, send_hash, {tpl_id: tpl}
    end
end
