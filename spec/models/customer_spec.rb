# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should belong_to :user }
  it { should have_one :customer_reg_info }
  it { should have_many :member_cards }
  it { should have_one :jajin }
  it { should have_one :pension }
  it { should have_many :friendships }


  it "should add friend then remove friend" do
    customer = Customer.create
    friend = Customer.create
    customer.add_friend! friend
    expect(customer.has_friend? friend).to be true
    customer.remove_friend! friend
    expect(customer.has_friend? friend).to be false
  end

  it "should have friend" do
    customer = Customer.create
    friend = Customer.create
    customer.add_friend! friend
    expect(customer.has_friend? friend).to be true
  end

  it "should have no friend" do
    customer = Customer.create
    friend = Customer.create
    expect(customer.has_friend? friend).to be false
  end

end
