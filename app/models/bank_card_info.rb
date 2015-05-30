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

class BankCardInfo < ActiveRecord::Base
end
