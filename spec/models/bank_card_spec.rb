# == Schema Information
#
# Table name: bank_cards
#
#  id          :integer          not null, primary key
#  bankcard_no :string(255)
#  id_card     :string(255)
#  name        :string(255)
#  phone       :string(255)
#  card_type   :integer
#  sn          :string(255)
#  bank        :integer
#  bind_state  :integer
#  bind_time   :datetime
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe BankCard, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
