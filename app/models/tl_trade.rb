# == Schema Information
#
# Table name: tl_trades
#
#  id             :integer          not null, primary key
#  phone          :string(255)
#  card           :string(255)
#  price          :float(24)
#  pos_ind        :string(255)
#  shop_ind       :string(255)
#  trade_ind      :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  customer_id    :integer
#  merchant_id    :integer
#  trade_time     :string(255)
#  pos_machine_id :integer
#  shop_id        :integer
#

class TlTrade < ActiveRecord::Base

  belongs_to :customer
  belongs_to :merchant
  belongs_to :shop
  belongs_to :pos_machine
  has_one :jajin_log, as: :jajinable

  validates_presence_of :customer, on: :create
  # validates_presence_of :merchant, on: :create

  before_validation :check_user, on: :create, if: "customer.nil?"
  before_validation :check_pos_machine, on: :create
  validate :must_have_jajin, on: :create
  validate :must_have_merchant, on: :create
  validates :phone, length: { is: 11 }

  after_create :calculate
  after_create :add_jajin_log

  after_create :add_jajin_identity_code

  scope :sum_day_price, -> { where("created_at > ?", Time.zone.now - 1.day).sum(:price) }
  scope :sum_week_price, -> { where("created_at > ?", Time.zone.now - 1.week).sum(:price) }
  scope :sum_month_price, -> { where("created_at > ?", Time.zone.now - 1.month).sum(:price) }
  scope :all_price, -> { all.sum(:price) }

  scope :day_price_merchant, -> { where("created_at > ?", Time.zone.now - 1.day).group(:merchant_id).pluck(:merchant_id) }
  scope :week_price_merchant, -> { where("created_at > ?", Time.zone.now - 1.week).group(:merchant_id).pluck(:merchant_id) }
  scope :month_price_merchant, -> { where("created_at > ?", Time.zone.now - 1.month).group(:merchant_id).pluck(:merchant_id) }
  scope :all_price_merchant, -> { all.group(:merchant_id).pluck(:merchant_id) }

  def as_json(options=nil)
    {
      phone: phone,
      card: card,
      price: price,
      trade_time: trade_time,
      pos_ind: pos_ind,
      shop_ind: shop_ind,
      trade_ind: trade_ind,
      customer_id: customer_id
    }
  end

  def company
    "刷卡返金"
  end

  private

  def check_user
    user = User.find_or_create_by_phone phone
    self.customer = user.customer
  end

  def check_pos_machine
    unique_ind = shop_ind+pos_ind
    pos_machine = PosMachine.find_by(pos_ind: unique_ind)
    if pos_machine.nil?
      pos_machine = PosMachine.create pos_ind: unique_ind
    end
    
    self.pos_machine = pos_machine
    self.shop = pos_machine.shop
    self.merchant_id = pos_machine.try(:shop).try(:merchant).try(:id) || 4
  end

  def must_have_jajin
    if self.customer.try(:jajin).blank?
      errors.add(:message, "小确幸账号不存在")
    end
  end

  def must_have_merchant
    # if self.try(:merchant).blank?
    #   errors.add(:message, "商户不存在")
    # end
  end

  def calculate
    jajin = self.customer.jajin
    ratio = merchant.try(:ratio) || 0.01
    amount = (price * 100 * ratio).ceil
    jajin.got += amount
    jajin.save!
  end

  def add_jajin_log
    ratio = merchant.try(:ratio) || 0.01
    amount = (price * 100 * ratio).ceil
    self.create_jajin_log customer: customer, amount: amount, merchant_id: merchant_id
  end

  def add_jajin_identity_code
    if phone.blank?
      JajinIdentityCode.create amount: price, trade_time: trade_time, verify_state: "unverified", verify_code: trade_ind, merchant_id: 4
    end
  end

end
