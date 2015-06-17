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

class Agent < ActiveRecord::Base
end
