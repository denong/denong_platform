# == Schema Information
#
# Table name: telecom_users
#
#  id         :integer          not null, primary key
#  phone      :string(255)
#  name       :string(255)
#  id_card    :string(255)
#  point      :float(24)
#  unique_ind :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class TelecomUser < ActiveRecord::Base
  validates_uniqueness_of :phone
  validates_presence_of :phone

  validate :check_phone_length

  def check_phone_length
    if self.phone.size == 11
      errors.add(:phone, "its length can not be 11")
    end
  end

end
