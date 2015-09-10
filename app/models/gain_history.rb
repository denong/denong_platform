# == Schema Information
#
# Table name: gain_histories
#
#  id              :integer          not null, primary key
#  gain            :float(24)
#  gain_date       :datetime
#  customer_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  gain_account_id :integer
#

class GainHistory < ActiveRecord::Base
  belongs_to :customer
  belongs_to :gain_account
end
