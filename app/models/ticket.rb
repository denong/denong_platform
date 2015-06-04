# == Schema Information
#
# Table name: tickets
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Ticket < ActiveRecord::Base
  belongs_to :customer

  validates_uniqueness_of :customer_id
  
  has_one :jajin_log, as: :jajinable
  before_save :calculate
  before_save :add_jajin_log

  def company
    "拍小票送小金"
  end

  private

    def add_jajin_log
      self.create_jajin_log customer: customer, amount: 10, merchant_id: 3
    end

    def calculate
      jajin = self.customer.jajin
      jajin.got += 10
      jajin.save!
    end

end
