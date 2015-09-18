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

  def self.verify_process params
    # api_key, id_card, name, phone, point, unique_ind, sign, timestamp

    # 10001 表示 签名验证失败
    return 10001 unless data_verify params

    timestamp = params[:timestamp]
    merchant_user = MerchantUser.find_by(api_key: params[:api_key])
    params[:merchant_id] = merchant_user.try(:merchant).try(:id) if merchant_user.present?
    process_one_data params, DateTime.new(timestamp[0..3].to_i, timestamp[4..5].to_i, timestamp[6..7].to_i)
  end

  def self.data_verify hash
    params_array = []
    hash.to_a.each do |param|
      next if param.include? "sign"
      params_array << param.join
    end

    params_array.sort!
    origin_string = params_array.join
    result = EncryptRsa.verify hash[:sign], origin_string, "public_key3.pem"
    result
  end

  # 处理数据
  def self.process key
    datetime = key.split('_')[-1]
    datas = $redis.hvals("#{key}")
    error_logs = []
    merchant = Merchant.find_by(id: 162)
    datas.each do |data|
      begin
        data = eval data
      rescue Exception => e
        logger.info "Exception is #{e}, data is #{data}"
      end
      data[:merchant_id] = 162
      process_one_data data, datetime
    end
    $redis.del("#{key}")
  end

  def self.process_one_data data, datetime

    # phone, id_card, name, unique_ind, point, merchant
    # 手机号  身份证号  姓名  交易的唯一标示 兑换积分数

    phone = data[:phone] || data['手机号']
    name = data[:name] || data['姓名']
    id_card = data[:id_card] || data['身份证号']
    unique_ind = data[:unique_ind] || data['交易的唯一标示']
    point = data[:point] || data['兑换积分数']
    merchant = Merchant.find_by(id: data[:merchant_id]) if data[:merchant_id].present?

    unless phone.present? && name.present? && id_card.present? && unique_ind.present? && point.present? && merchant.present?
      return error_process datetime, data, 10002, "数据缺失"
    end

    user, result = User.build_by_phone(phone)
    # 如果有错误，则增加错误信息
    if user.errors.present?
      return error_process datetime, data, 10003, user.errors.full_messages.to_s
    end

    # 校验用户是否实名制认证
    customer_reg_info = CustomerRegInfo.get_reg_info_by_phone(phone: phone, name: name, id_card: id_card)
    if customer_reg_info.errors.present?
      return error_process datetime, data, 10004, customer_reg_info.errors.full_messages.to_s
    end

    if customer_reg_info.verify_state != "verified"
      identity_verify = user.try(:customer).identity_verifies.build(id_card: id_card, name: name)
      identity_verify.save

      # 如果有错误，则增加错误信息
      if identity_verify.verify_state != "verified"
        return error_process datetime, data, 10005, "用户实名制认证失败！"
      end
    end

    # 用户是否授权会员卡
    if merchant.present? && user.present? && user.try(:customer).present?
      member_card = merchant.try(:member_cards).find_by_customer_id(user.try(:customer).try(:id))
      unless member_card.present?
        member_card = MemberCard.find_or_create_by(customer: user.try(:customer), merchant: merchant, user_name: name, passwd: id_card, point: 0)
      end
    end

    # 如果有错误，则增加错误信息
    if member_card.errors.present?
      return error_process datetime, data, 10006, member_card.errors.full_messages.to_s
    end

    # 获得小金
    member_card_point_log = MemberCardPointLog.find_by(unique_ind: unique_ind)
    if member_card_point_log.present?
      # 已经存在
      return error_process datetime, data, 10007, "唯一标示已经存在"
    else
      member_card_point_log = member_card.member_card_point_logs.create(point: (-1)*point.to_i, member_card: member_card, unique_ind: unique_ind, customer: user.try(:customer))
    end

    if member_card_point_log.errors.present?
      return error_process datetime, data, 10008, member_card_point_log.errors.full_messages.to_s
    end

    params = {}
    params[:customer_id] = user.try(:customer).id
    params[:point] = point
    MemberCardPointLog.send_sms_notification params, !result unless member_card_point_log.errors.present?
    return 0, "成功"
  end

  def self.error_process datetime, data, error_code, reason
    data[:error_code] = error_code
    data['错误原因'] = reason
    add_error_infos datetime, data
    return error_code, reason
  end

  # 开线程
  def self.process_data_from_cache
    keys = $redis.keys("process_data_cache_*")
    keys.each do |key|
      process(key)
      $redis.del("#{key}")
    end
  end

  def self.add_error_infos datetime, data
    
    if data['交易的唯一标示'].nil?
      key = DateTime.now.strftime("%Y%m%d%H%M%S") + (0..9).to_a.sample(8).join
    else
      key = data['交易的唯一标示']
    end
    $redis.hset("error_logs_#{datetime}", "#{key}", data)

    PointLogFailureInfo.create(id_card: data[:id_card], name: data[:name],
      phone: data[:phone], point: data[:point], unique_ind: data[:unique_ind],
      merchant_id: data[:merchant_id], error_code: data[:error_code])
  end

  # 处理上传数据,写入缓存
  # 按文件分类
  def import(file)
    key = "process_data_cache_#{Time.now.strftime('%Y%m%d%H%M')}"
    begin
      spreadsheet = MemberCardPointLog.open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |r|
        row = Hash[[header, spreadsheet.row(r)].transpose]

        unless row['交易的唯一标示'].present?
          MemberCardPointLog.add_error_infos row, "唯一标示不能为空"
          next
        end
        # 存入缓存
        $redis.hset(key, "#{row['交易的唯一标示']}", row)
      end
    rescue Exception => e
      p e
    end
    # MemberCardPointLog.process_data_from_cache key
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
    result = nil
    file_type = File.extname(file)
    case file_type
    when ".csv" then result = Roo::CSV.new(file.path)
    when ".xls" then result = Roo::Excel.new(file.path)
    when ".xlsx" then result = Roo::Excelx.new(file.path)
    else raise "未知格式: #{file}"
    end
    result
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
    money = params[:point].to_f.abs.to_f/100

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
