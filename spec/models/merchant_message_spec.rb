# == Schema Information
#
# Table name: merchant_messages
#
#  id          :integer          not null, primary key
#  time        :datetime
#  title       :string(255)
#  content     :string(255)
#  summary     :string(255)
#  url         :string(255)
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe MerchantMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
