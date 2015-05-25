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

  def add_jajin_log
    self.create_jajin_log customer: customer, amount: 10
  end
end
