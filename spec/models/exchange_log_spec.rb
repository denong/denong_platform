# == Schema Information
#
# Table name: exchange_logs
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  amount      :float
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe ExchangeLog, type: :model do
  it { should belong_to :customer }
  it { should have_one :jajin_log }

  
  describe "加金转养老金" do
    
    let(:customer)                  { create(:customer_with_jajin_pension) }
    let(:customer_with_jajin)       { create(:customer_with_jajin) }
    let(:customer_with_pension)     { create(:customer_with_pension)  }

    context "加金转养老金成功" do

      before(:each) do
       @exchange_log = create(:exchange_log, customer: customer, amount: 1.5)
      end

      it "should increase the count of exchange log by 1" do
        expectation = expect {create(:exchange_log, customer: customer, amount: 1.5)}
        expectation.to change{ExchangeLog.count}.by 1
      end

      it "should decrease the got of customer jajin by amount" do
        expect(@exchange_log.customer.jajin.got).to eq(188.88 - 1.5)
      end

      it "should make the amount of jajin_log equal to the amount" do
        expect(@exchange_log.jajin_log.amount).to eq 1.5
      end

      it "should make the customer of jajin_log equal to the customer of exchange_log" do
        expect(@exchange_log.jajin_log.customer).to eq @exchange_log.customer
      end

      it "should increase the total of customer pension by amount divide 100" do
        expect(@exchange_log.customer.pension.total).to eq(88.88+1.5/100)
      end
    end

    context "加金转养老金失败" do

      it "should raise error the jajin is not exist" do
        exchange_log = build(:exchange_log, customer: customer_with_pension, amount: 1.5)
        expect(exchange_log).not_to be_valid
        expect(exchange_log.errors.full_messages).to be_include("提示：加金宝账号不存在")
      end

      it "should raise error the pesion is not exist" do
        exchange_log = build(:exchange_log, customer: customer_with_jajin, amount: 1.5)
        expect(exchange_log).not_to be_valid
        expect(exchange_log.errors.full_messages).to be_include("提示：养老金账号不存在")
      end

      it "should raise error that the change amount cannot be bigger than the available amount" do
        exchange_log = build(:exchange_log, customer: customer, amount: 200)
        expect(exchange_log).not_to be_valid
        expect(exchange_log.errors.full_messages).to be_include("转换金额不能大于加金可用余额")
      end

    end
    
  end
end
