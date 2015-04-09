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
#

class Merchant < ActiveRecord::Base
  acts_as_votable
  
  belongs_to :merchant_user 
  has_one :busi_reg_info, class_name: "MerchantBusiRegInfo", dependent: :destroy
  has_one :sys_reg_info, class_name: "MerchantSysRegInfo", dependent: :destroy
  has_many :shops
  has_many :member_cards
  has_many :tl_trades
  has_one :thumb, class_name: "Image", as: :imageable, dependent: :destroy

  after_create :add_sys_reg_info
  after_create :add_busi_reg_info

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

end
