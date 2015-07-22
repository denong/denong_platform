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
  
  def company
    "积分转小金"
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
