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

require 'rails_helper'

RSpec.describe PointLogFailureInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
