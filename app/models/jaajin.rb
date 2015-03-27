# == Schema Information
#
# Table name: jaajins
#
#  id          :integer          not null, primary key
#  got         :float
#  unverify    :float
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Jaajin < ActiveRecord::Base
  belongs_to :customer
end
