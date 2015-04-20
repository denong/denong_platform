class GainAccount < ActiveRecord::Base
  belongs_to :customer
  belongs_to :gain_org
end
