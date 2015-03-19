class PosMachine < ActiveRecord::Base
  enum acquiring_bank: [ :unionpay, :lakala, :allinpay]
  belongs_to :shop
end
