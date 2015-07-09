class MerchantCustomer < ActiveRecord::Base
  validates :u_id, presence: true
  validates :name, presence: true
  validates :password, presence: true

  belongs_to :merchant



end
