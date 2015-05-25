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
end
