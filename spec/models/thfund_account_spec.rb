# == Schema Information
#
# Table name: thfund_accounts
#
#  id                 :integer          not null, primary key
#  sn                 :integer
#  certification_type :integer
#  certification_no   :string(255)
#  name               :string(255)
#  transaction_time   :datetime
#  account_id         :integer
#  mobile             :string(255)
#  customer_id        :integer
#  state              :integer
#  created_at         :datetime
#  updated_at         :datetime
#  return_code        :integer
#

require 'rails_helper'

RSpec.describe ThfundAccount, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
