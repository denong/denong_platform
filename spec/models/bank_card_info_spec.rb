# == Schema Information
#
# Table name: bank_card_infos
#
#  id         :integer          not null, primary key
#  bin        :string(255)
#  bank       :string(255)
#  card_type  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe BankCardInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
