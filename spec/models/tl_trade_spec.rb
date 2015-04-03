# == Schema Information
#
# Table name: tl_trades
#
#  id          :integer          not null, primary key
#  phone       :string(255)
#  card        :string(255)
#  price       :float
#  trade_time  :datetime
#  pos_ind     :string(255)
#  shop_ind    :string(255)
#  trade_ind   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#  merchant_id :integer
#

require 'rails_helper'

RSpec.describe TlTrade, type: :model do
  it { should belong_to :customer }
  it { should belong_to :merchant }
  it { should have_one :jajin_log }

  let(:customer)  { create(:customer_with_jajin_pension) }
  let(:merchant)  { create(:merchant) }
  describe "用户存在" do
    
    # context "test 1" do
    #   before(:each) do
    #     @tl_trades = create(:tl_trade, customer: customer, merchant: merchant)      
    #   end

    #   it "should increase the count of exchange log by 1" do
    #     expectation = expect {create(:tl_trade, merchant: merchant)}# customer: customer,
    #     expectation.to change{TlTrade.count}.by 1
    #   end

    #   it "should decrease the got of customer jajin by amount" do
    #     #expect(@tl_trades.customer.jajin.got).to eq(188.88 - 1.5)
    #   end
    # end



  end

end