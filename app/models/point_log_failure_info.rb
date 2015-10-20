# == Schema Information
#
# Table name: point_log_failure_infos
#
#  id          :integer          not null, primary key
#  id_card     :string(255)
#  name        :string(255)
#  phone       :string(255)
#  point       :integer
#  unique_ind  :string(255)
#  merchant_id :integer
#  error_code  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class PointLogFailureInfo < ActiveRecord::Base
  belongs_to :merchant


  # PointLogFailureInfo.create_telecom_user_by_data
  def self.create_telecom_user_by_data
    errors = []
    PointLogFailureInfo.where(error_code: "10003").each do |p|
      next unless p.phone.present?
      if p.point.to_i.abs < 1000
        point = 500
      elsif p.point.to_i.abs >= 1000
        point = 1000
      end
      begin
        TelecomUser.create(phone: p.phone, name: p.name, id_card: p.id_card, point: point, unique_ind: p.unique_ind)
      rescue Exception => e
        puts "exception is #{e}"
        errors << p.phone
      end
    end
    errors
  end
end
