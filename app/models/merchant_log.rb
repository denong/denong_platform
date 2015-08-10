# == Schema Information
#
# Table name: merchant_logs
#
#  id            :integer          not null, primary key
#  datetime      :datetime
#  data_type     :string(255)
#  name          :string(255)
#  d_jajin_count :float(24)
#  w_jajin_count :float(24)
#  m_jajin_count :float(24)
#  all_jajin     :float(24)
#  d_user_count  :integer
#  w_user_count  :integer
#  m_user_count  :integer
#  all_user      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class MerchantLog < ActiveRecord::Base

  def process
    now_day = Time.zone.now
    merchant_log = MerchantLog.find_or_create_by(datetime: (now_day.to_date - 1.day) + 8.hours, data_type: "商户")

  end
end
