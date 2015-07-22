# == Schema Information
#
# Table name: data_reports
#
#  id              :integer          not null, primary key
#  report_date     :datetime
#  u_day_count     :float            default(0.0)
#  u_month_count   :float            default(0.0)
#  u_sum           :float            default(0.0)
#  ul_day_count    :float
#  ul_month_count  :float
#  ul_sum          :float
#  j_day_count     :float            default(0.0)
#  j_month_count   :float            default(0.0)
#  j_sum           :float            default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  u_ios_count     :float            default(0.0)
#  u_android_count :float            default(0.0)
#  u_other_count   :float            default(0.0)
#

require 'rails_helper'

RSpec.describe DataReport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
