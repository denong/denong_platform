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
  it { should have_many :jajin_logs }
  it { should have_many :bank_cards }
  it { should have_many :identity_verifies }
  it { should have_many :gain_histories }
  it { should have_many :yl_trades }

  describe "friendships" do
    before(:each) do
      @user = Customer.create
      @friend = Customer.create
    end

    it "should have a friendships method" do
      expect(@user).to respond_to :friendships
    end

    it "should have a add_friend! method" do
      expect(@user).to respond_to :add_friend!
    end

    it "should have a has_friend? method" do
      expect(@user).to respond_to :has_friend?
    end

    it "should have a remove_friend! method" do
      expect(@user).to respond_to :remove_friend!
    end

    it "should add a friend" do
      @user.add_friend! @friend
      expect(@user.has_friend? @friend).to be true
    end

    it "should have a friend in friendship array" do
      @user.add_friend! @friend
      expect(@user.friends).to include @friend
    end

    it "should add and remove a friend" do
      @user.add_friend! @friend
      @user.remove_friend! @friend
      expect(@user.has_friend? @friend).to be false
    end

    it "should remove a friend" do
      @user.add_friend! @friend
      expect(@user.remove_friend! @friend).to be_present
    end

    it "should not remove a friend" do
      expect(@user.remove_friend! @friend).to be_blank
    end
  end

  describe "votables" do
    let(:customer) { create(:customer) }
    let(:shop) { create(:shop) }

    it "follow and unfollow" do
      expect {
        customer.follow!(shop)
      }.to change{ shop.votes_up }.from(0).to(1)
      
      customer.follow! shop
      expect(shop.votes_up).to eq 1

      expect {
        customer.unfollow!(shop)
      }.to change{ shop.votes_up }.from(1).to(0)
    end


  end

end
