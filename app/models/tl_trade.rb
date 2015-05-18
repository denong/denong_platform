# == Schema Information
#
# Table name: tl_trades
#
#  id             :integer          not null, primary key
#  phone          :string(255)
#  card           :string(255)
#  price          :float
#  pos_ind        :string(255)
#  shop_ind       :string(255)
#  trade_ind      :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  customer_id    :integer
#  merchant_id    :integer
#  trade_time     :string(255)
#  pos_machine_id :integer
#

class TlTrade < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
  belongs_to :pos_machine
  has_one :jajin_log, as: :jajinable

  validates_presence_of :customer, on: :create
  # validates_presence_of :merchant, on: :create

  before_validation :check_user, on: :create, if: "customer.nil?"
  before_validation :check_pos_machine, on: :create
  validate :must_have_jajin, on: :create
  validate :must_have_merchant, on: :create
  validates :phone, length: { is: 11 }

  before_save :calculate
  before_save :add_jajin_log

  after_create :add_jajin_identity_code

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
     
    # 获取merchant信息
    # merchant_info = merchant.sys_reg_info
    # {
    #   card: card,
    #   price: price,
    #   merchant_name: merchant_info.sys_name,
    #   merchant_image: merchant_info.image ? image_url(merchant_info.image.photo.url(:small)) : nil
    # }
  end

  private

  def check_user
    user = User.find_or_create_by_phone phone
    self.customer = user.customer
  end

  def check_pos_machine
    pos_machine = PosMachine.find_by_pos_ind(pos_ind)  
    if pos_machine.nil?
      pos_machine = PosMachine.create! pos_ind: pos_ind
    end
    self.pos_machine = pos_machine
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
    jajin.got += price
    jajin.save!
  end

  def add_jajin_log
    self.create_jajin_log customer: customer, amount: price
  end

  def add_jajin_identity_code
    JajinIdentityCode.create amount: price, trade_time: trade_time, verify_state: "unverified", verify_code: trade_ind
  end

end
