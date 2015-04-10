# == Schema Information
#
# Table name: gain_histories
#
#  id          :integer          not null, primary key
#  gain        :float
#  gain_date   :datetime
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class GainHistory < ActiveRecord::Base
  belongs_to :customer
end