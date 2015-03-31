# == Schema Information
#
# Table name: jajin_logs
#
#  id             :integer          not null, primary key
#  amount         :float
#  jajinable_id   :integer
#  jajinable_type :string(255)
#  customer_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class JajinLog < ActiveRecord::Base
  belongs_to :jajinable, polymorphic: true
  belongs_to :customer
end
