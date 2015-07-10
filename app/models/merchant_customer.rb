# == Schema Information
#
# Table name: merchant_customers
#
#  id          :integer          not null, primary key
#  u_id        :string(255)      default(""), not null
#  password    :string(255)      default(""), not null
#  name        :string(255)
#  phone       :string(255)
#  jifen       :float
#  is_changed  :integer
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#

class MerchantCustomer < ActiveRecord::Base
  validates :u_id, presence: true
  validates :name, presence: true
  validates :password, presence: true

  belongs_to :merchant



end
