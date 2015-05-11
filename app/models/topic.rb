# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  tags       :string(255)      default("--- []\n")
#

class Topic < ActiveRecord::Base
  serialize :tags, Array
  has_many :merchants, dependent: :destroy
  has_one :pic, class_name: "Image", as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :pic, allow_destroy: true
  
  after_create :add_merchant_by_tags

  def add_merchant merchant_params
    merchant =  Merchant.find(merchant_params[:merchant_id])
    if merchant.present?
      self.merchants << merchant
    end
  end

  def add_merchant_by_tags
    self.merchants |= Merchant.tagged_with(tags, :any => true)
  end
end
