# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subtitle   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Topic < ActiveRecord::Base
  has_many :merchants, dependent: :destroy
  has_one :pic, class_name: "Image", as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :pic, allow_destroy: true
  
  acts_as_taggable
  # acts_as_taggable_on :merchants

  def add_merchant merchant_params
    merchant =  Merchant.find(merchant_params[:merchant_id])
    # puts "merchant is #{merchant.inspect}"
    if merchant.present?
      self.merchants << merchant
    end
  end

  def add_tag tag_params
    
  end
end
