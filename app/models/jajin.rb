# == Schema Information
#
# Table name: jajins
#
#  id          :integer          not null, primary key
#  got         :float
#  unverify    :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Jajin < ActiveRecord::Base
  belongs_to :customer

  def get_customer_jajin customer_id
    
  end

  def get_merchant_jajin merchant_id
    
  end
  
end
