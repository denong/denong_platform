# == Schema Information
#
# Table name: merchant_logs
#
#  id            :integer          not null, primary key
#  datetime      :datetime
#  data_type     :string(255)
#  name          :string(255)
#  d_jajin_count :float
#  w_jajin_count :float
#  m_jajin_count :float
#  all_jajin     :float
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
