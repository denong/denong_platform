# == Schema Information
#
# Table name: lakala_trades
#
#  id             :integer          not null, primary key
#  phone          :string(255)
#  card           :string(255)
#  price          :float(24)
#  pos_ind        :string(255)
#  shop_ind       :string(255)
#  trade_ind      :string(255)
#  trade_time     :string(255)
#  pos_machine_id :integer
#  shop_id        :integer
#  customer_id    :integer
#  merchant_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  amount         :float(24)
#

class LakalaTrade < ActiveRecord::Base
  belongs_to :pos_machine
  belongs_to :shop
  belongs_to :customer
  belongs_to :merchant
  has_one :jajin_log, as: :jajinable

  before_validation :check_user, on: :create, if: "phone.present?"
  before_validation :check_pos_machine, on: :create
  validates :phone, length: { is: 11 }, if: "phone.present?"

  after_create :calculate, if: "phone.present?"
  after_create :add_jajin_log, if: "phone.present?"
  after_create :add_jajin_identity_code, if: "phone.blank?"

  def self.process params
    
    return 10001 unless data_verify params

    unless params["card"].present? && params["price"].present? && 
      params["pos_ind"].present? && params["shop_ind"].present? && 
      params["trade_ind"].present? && params["trade_time"].present?
      return 10002, "参数缺失"
    end

    if params["phone"].present?
      count = $redis.hget("lakala_#{Date.today.to_s}", "#{params["phone"]}").to_i
      return 10003, "用户请求次数超限" if count >= 2
      $redis.hset("lakala_#{Date.today.to_s}", "#{params["phone"]}", count+=1)
    end

    return 10004, "流水号已经存在" if LakalaTrade.exists? trade_ind: params["trade_ind"]

    LakalaTrade.create(phone: params["phone"], price: params["price"], card: params["card"],
      pos_ind: params["pos_ind"], shop_ind: params["shop_ind"],
      trade_ind: params["trade_ind"], trade_time: params["trade_time"])
    return 0, "成功"
  end

  def self.data_verify hash
    params_array = []
    hash.to_a.each do |param|
      next if ["sign", "action", "controller", "lakala_trade"].include? param[0]
      params_array << param.join
    end

    params_array.sort!
    origin_string = params_array.join
    result = (Digest::MD5.hexdigest(origin_string) == hash["sign"])
    result
  end

  def company
    "刷卡返金"
  end

  private

  def check_user
    if phone.present?
      user = User.find_or_create_by_phone phone
      self.customer = user.customer
    end
  end

  def check_pos_machine
    unique_ind = shop_ind+pos_ind
    pos_machine = PosMachine.find_or_create_by(pos_ind: unique_ind)
    
    self.pos_machine = pos_machine
    self.shop = pos_machine.shop
    self.merchant_id = pos_machine.try(:shop).try(:merchant).try(:id) || 263
  end

  def calculate
    jajin = self.customer.jajin
    jajin.got += calc_amount
    jajin.save!
  end

  def calc_amount
    ratio = merchant.try(:ratio) || 0.01
    if price > 0
      amount = (price * 100 * ratio).ceil
    else
      amount = (price * 100 * ratio).floor
    end
    amount
  end

  def add_jajin_log
    ratio = merchant.try(:ratio) || 0.01
    amount = (price * 100 * ratio).ceil
    self.create_jajin_log customer: customer, amount: amount, merchant_id: merchant_id
  end

  def add_jajin_identity_code
    amount = calc_amount
    if price > 0
      JajinIdentityCode.create amount: amount, trade_time: trade_time, verify_state: "unverified", verify_code: trade_ind, merchant_id: 263
    else
      j = JajinIdentityCode.find_by(amount: amount.abs, trade_time: trade_time, merchant_id: 263)
      return unless j.present?
      j.verify_state = "verified"
      j.save
    end

  end

end
