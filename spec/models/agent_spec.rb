# == Schema Information
#
# Table name: agents
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  contact_person         :string(255)
#  phone                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  fax                    :string(255)
#  addr                   :string(255)
#  lat                    :float(24)        default(0.0)
#  lon                    :float(24)        default(0.0)
#  created_at             :datetime
#  updated_at             :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  authentication_token   :string(255)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

require 'rails_helper'

RSpec.describe Agent, type: :model do
end
