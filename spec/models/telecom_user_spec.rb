# == Schema Information
#
# Table name: telecom_users
#
#  id         :integer          not null, primary key
#  phone      :string(255)
#  name       :string(255)
#  id_card    :string(255)
#  point      :float(24)
#  unique_ind :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe TelecomUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
