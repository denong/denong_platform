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
  has_one :thumb, class_name: "Image", as: :imageable, dependent: :destroy
  has_many :yl_trades, dependent: :destroy
  has_many :merchant_messages, dependent: :destroy
  has_many :merchant_giving_logs, dependent: :destroy

  after_create :add_sys_reg_info
  after_create :add_busi_reg_info

  def get_giving_jajin
    self.merchant_giving_logs.sum(:amount)
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
