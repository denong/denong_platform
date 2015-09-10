# == Schema Information
#
# Table name: jajins
#
#  id          :integer          not null, primary key
#  got         :float(24)
#  unverify    :float(24)
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Jajin < ActiveRecord::Base
  belongs_to :customer
end
