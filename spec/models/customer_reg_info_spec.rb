# == Schema Information
#
# Table name: customer_reg_infos
#
#  id           :integer          not null, primary key
#  customer_id  :integer
#  name         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  verify_state :integer
#  id_card      :string(255)
#  nick_name    :string(255)
#  gender       :integer
#

require 'rails_helper'

RSpec.describe CustomerRegInfo, type: :model do
  it { should belong_to :customer }
end
