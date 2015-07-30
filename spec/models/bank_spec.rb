# == Schema Information
#
# Table name: banks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Bank, type: :model do
  it { should have_searchable_field :name }

  it 'searches for users' do
    BankSearch.search(name: 'John Doe')
    Sunspot.session.should be_a_search_for(Bank)
    expect(customer_with_jajin_pension.jajin.got).to eq(188.88 + amount)
  end
end
