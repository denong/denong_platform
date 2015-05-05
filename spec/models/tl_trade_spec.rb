# == Schema Information
#
# Table name: tl_trades
#
#  id             :integer          not null, primary key
#  phone          :string(255)
#  card           :string(255)
#  price          :float
#  pos_ind        :string(255)
#  shop_ind       :string(255)
#  trade_ind      :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  customer_id    :integer
#  merchant_id    :integer
#  trade_time     :string(255)
#  pos_machine_id :integer
#

require 'rails_helper'

RSpec.describe TlTrade, type: :model do
  it { should belong_to :customer }
  it { should belong_to :merchant }
  it { should belong_to :pos_machine }
  it { should have_one :jajin_log }

  let(:customer)  { create(:customer_with_jajin_pension) }
  let(:merchant)  { create(:merchant) }

  describe "tl_trade" do
    before(:each) do
      @tl_trades = create(:tl_trade, customer: customer, merchant: merchant)
    end

    it "should increase the count of exchange log by 1" do
      expectation = expect {create(:tl_trade, customer: customer, merchant: merchant)}# 
      expectation.to change{TlTrade.count}.by 1
    end

    it "should add the got of customer jajin by price/100" do
      expect(@tl_trades.customer.jajin.got).to eq(188.88 + 888.88)
    end

    it "should make the customer of jajin_log equal to the customer of tl_trades" do
      expect(@tl_trades.jajin_log.customer).to eq @tl_trades.customer
    end

    it "should automatic add customer" do
      tl_trades_without_customer = create(:tl_trade, merchant: merchant)      
      expect(tl_trades_without_customer.customer).not_to be_nil
    end

    it "should automatic add pos machine" do
      tl_trades_without_pos_machine = create(:tl_trade, merchant: merchant)
      puts "#{tl_trades_without_pos_machine.pos_machine.inspect}"    
      expect(tl_trades_without_pos_machine.pos_machine).not_to be_nil
    end
    # context "通联交易记录创建失败" do
    #   it "should raise error the merchant is not exist" do
    #     tl_trades = build(:tl_trade, customer: customer)
    #     expect(tl_trades).not_to be_valid
    #     expect(tl_trades.errors.full_messages).to be_include("提示：商户不存在")
    #   end
    # end
  end
end
