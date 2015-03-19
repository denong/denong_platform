# == Schema Information
#
# Table name: pos_machines
#
#  id             :integer          not null, primary key
#  acquiring_bank :integer
#  operator       :string(255)
#  opertion_time  :datetime
#  shop_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class PosMachine < ActiveRecord::Base
  enum acquiring_bank: [ :unionpay, :lakala, :allinpay]
  belongs_to :shop
end
