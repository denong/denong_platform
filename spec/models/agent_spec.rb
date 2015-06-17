# == Schema Information
#
# Table name: agents
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  phone          :string(255)
#  contact_person :string(255)
#  email          :string(255)
#  fax            :string(255)
#  addr           :string(255)
#  lat            :float
#  lon            :float
#  created_at     :datetime
#  updated_at     :datetime
#

require 'rails_helper'

RSpec.describe Agent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
