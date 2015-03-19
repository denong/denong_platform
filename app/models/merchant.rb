# == Schema Information
#
# Table name: merchants
#
#  id               :integer          not null, primary key
#  merchant_user_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Merchant < ActiveRecord::Base
  belongs_to :merchant_user 
  has_many :shops
end
