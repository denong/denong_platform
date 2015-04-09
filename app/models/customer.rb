# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  acts_as_voter

  belongs_to :user
  has_one :customer_reg_info, dependent: :destroy
  has_many :member_cards, dependent: :destroy
  has_one :jajin, dependent: :destroy
  has_one :pension, dependent: :destroy
  has_many :identity_verifies, dependent: :destroy
  has_many :bank_cards, dependent: :destroy
  # 亲友关系
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, dependent: :destroy
  # 加金详细记录
  has_many :jajin_logs, dependent: :destroy
  # 加金转养老金记录
  has_many :exchange_logs, dependent: :destroy
  # 养老金收益记录
  has_many :gain_histories, dependent: :destroy
  # 银联记录
  has_many :yl_trades, dependent: :destroy
  # 商户推送消息
  has_many :merchant_messages, dependent: :destroy

  after_create :add_jajin
  after_create :add_customer_reg_info

  def add_friend! customer
    self.friendships.find_or_create_by!(friend_id: customer.id)
  end

  def has_friend? customer
    self.friendships.find_by_friend_id(customer).present?
  end

  def remove_friend! customer
    self.friendships.find_by_friend_id(customer).try(:destroy)
  end

  def add_jajin
    self.create_jajin(got: 0,unverify: 0) if self.jajin.blank?
  end

  def add_customer_reg_info
    self.create_customer_reg_info( audit_state: :unverified )
  end

  def follow! votable
    self.likes votable
  end

  def unfollow! votable
    self.unlike votable
  end

  def bind_member_card! member_card
    self.member_cards << member_card
  end

end
