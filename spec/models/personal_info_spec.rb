# == Schema Information
#
# Table name: personal_infos
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  id_card    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  result     :integer
#

require 'rails_helper'

RSpec.describe PersonalInfo, type: :model do
end
