require 'rails_helper'

RSpec.describe PosMachine, type: :model do
  it { should belong_to :shop} 
end
