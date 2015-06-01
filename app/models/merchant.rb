# == Schema Information
#
# Table name: merchants
#
#  id                      :integer          not null, primary key
#  merchant_user_id        :integer
#  created_at              :datetime
#  updated_at              :datetime
#  ratio                   :float
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  topic_id                :integer
#  consumption_total       :float
#  jajin_total             :float
#  consume_count           :integer
#

class Merchant < ActiveRecord::Base
  acts_as_votable
  acts_as_taggable
  
  belongs_to :merchant_user 
  belongs_to :topic
  has_one :busi_reg_info, class_name: "MerchantBusiRegInfo", dependent: :destroy
  has_one :sys_reg_info, class_name: "MerchantSysRegInfo", dependent: :destroy
  has_many :shops
  has_many :member_cards
  has_many :tl_trades
  has_many :yl_trades, dependent: :destroy
  has_many :merchant_messages, dependent: :destroy
  has_many :merchant_giving_logs, dependent: :destroy
  has_many :jajin_logs, dependent: :destroy

  delegate :sys_name, :company_addr, :welcome_string, to: :sys_reg_info
  after_touch :index

  after_create :add_sys_reg_info
  after_create :add_busi_reg_info

  searchable do
    text :sys_name
    text :welcome_string
    integer :votes_up
  end

  def self.name_search search_text
    where("sys_name LIKE ?", "%#{search_text}%")
  end

  def get_giving_jajin
    self.jajin_logs.sum(:amount)
  end

  def add_sys_reg_info
    self.create_busi_reg_info
  end

  def add_busi_reg_info
    self.create_sys_reg_info
  end

  def votes_up 
    self.cached_votes_up
  end

  def follow_count
    self.get_likes(vote_scope: "follow").size
  end

  def like_count
    self.get_likes(vote_scope: "like").size
  end

  def customer_jajin_total customer
    self.jajin_logs.where(customer_id: customer.id).sum(:amount)
  end

  def bind_member_card! member_card
    self.member_cards << member_card
  end

  def add_tag tag_params
    tags = tag_params[:tags].split(',')
    self.tag_list.add tags
  end

  def get_follwers
    self.votes_for.by_type(User).voters
  end

end
