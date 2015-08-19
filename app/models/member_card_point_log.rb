# == Schema Information
#
# Table name: member_card_point_logs
#
#  id             :integer          not null, primary key
#  point          :float
#  jajin          :float
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

  validates_presence_of :customer, on: :create
  validates_presence_of :member_card, on: :create

  validate :must_point_negative, on: :create
  validate :must_have_jajin, on: :create
  validate :point_must_less_than_all_point, on: :create

  default_scope { order('id DESC') }

  scope :today, -> { where('created_at > ?', Time.zone.now.to_date - 1.day) }
  scope :week, -> { where('created_at > ?', Time.zone.now.to_date - 7.day ) }
  scope :month, -> { where('created_at > ?', Time.zone.now.to_date - 30.day ) }
  
  def company
    "积分转小金"
  end

  def self.get_point_log_by_merchant merchant_id, params
    phone = params[:phone]
    customer = User.find_by_phone(phone).try(:customer)
    if customer.nil?
      return
    end
    member_card = MemberCard.find_by(merchant_id: merchant_id, customer_id: customer.id)
    if member_card.present?
      member_card.try(:member_card_point_logs).where(created_at: params[:begin_time]..params[:end_time])
    else
      nil
    end
  end

  def self.get_all_merchant_log merchant_id
    
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

  private

    def must_point_negative
      unless point < 0
        errors.add(:point, "必须小于0")
      end
    end

    def must_have_jajin
      if self.customer.try(:jajin).blank?
        errors.add(:message, "小确幸账号不存在")
      else
        self.customer.create_jajin(got: 0,unverify: 0)
      end
      self.jajin = point.abs
    end

    def point_must_less_than_all_point
      if self.member_card.point.nil?
        self.member_card.point = 0
        self.member_card.save
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

end
