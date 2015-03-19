# == Schema Information
#
# Table name: shops
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  addr           :string(255)
#  contact_person :string(255)
#  contact_tel    :string(255)
#  work_time      :string(255)
#  merchant_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Shop < ActiveRecord::Base
  belongs_to :merchant
end
