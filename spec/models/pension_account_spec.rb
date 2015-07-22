# == Schema Information
#
# Table name: pension_accounts
#
#  id          :integer          not null, primary key
#  id_card     :string(255)
#  state       :integer          default(0)
#  customer_id :integer
#  account     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  phone       :string(255)
#  name        :string(255)
#

require 'rails_helper'

RSpec.describe PensionAccount, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
