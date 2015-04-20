require 'rails_helper'

RSpec.describe GainAccount, type: :model do
  it { should belong_to :customer }
  it { should belong_to :gain_org }
end
