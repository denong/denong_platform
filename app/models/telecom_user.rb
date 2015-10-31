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

  validates_uniqueness_of :id_card
  validates_presence_of :id_card
  
  validate :check_phone_length
  validate :check_personal_info

  def check_phone_length
    if self.phone.size == 11
      errors.add(:phone, "its length can not be 11")
    end
  end

  def check_personal_info
    if check_id_card_info name, id_card
      PersonalInfo.find_or_create_by(name: name, id_card: id_card, result: 0)
    else
      PersonalInfo.find_or_create_by(name: name, id_card: id_card, result: 1)
      errors.add(:id_card, "personal info error")
    end

  end


  def check_id_card_info name, id_card
    return false if name =~ /\p{Lt}|\p{Ll}|\p{Lm}|\p{Lt}|\p{Lu}|\p{N}|\p{P}|广场\z|办公室\z|医院\z|公司\z|小学\z/
    return false unless (id_card =~ /^(\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$/) && !(id_card =~ /\p{P}/)
    return true
  end


end
