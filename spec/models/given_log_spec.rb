# == Schema Information
#
# Table name: given_logs
#
#  id                :integer          not null, primary key
#  giver_or_given_id :integer
#  amount            :float
#  created_at        :datetime
#  updated_at        :datetime
#  customer_id       :integer
#

require 'rails_helper'

RSpec.describe GivenLog, type: :model do
  it { should have_one :jajin_log }
  it { should belong_to :customer }

  describe "加金转赠" do
    
    let(:user1)                       { create(:user, email: "example1@example.com", phone: "12345678902", password: "12345678", authentication_token: "qwertyuio")}
    let(:user2)                       { create(:user, email: "example2@example.com", phone: "12345678903", password: "12345678", authentication_token: "qwetyuio")}
    let(:customer)                    { create(:customer) }
    let(:customer_with_jajin)         { create(:customer_with_jajin) }
    let(:customer_with_jajin_pension) { create(:customer_with_jajin_pension, user: user2) }

    context "加金转赠成功" do
      
      let (:amount) { 8.88}
      before(:each) do
        giver_log, given_log = GivenLog.add_both_given_log customer_with_jajin, customer_with_jajin_pension, amount
      end

      it "should increase the count of given log " do
        expectation = expect {create(:given_log, customer_id: customer_with_jajin_pension.id, giver_or_given_id: customer_with_jajin.id, amount: amount)}
        expectation.to change{GivenLog.count}.from(2).to(3)
      end

      it "should decrease the got of giver by amount" do
        expect(customer_with_jajin.jajin.got).to eq(188.88 - amount)
      end

      it "should increase the got of given by amount" do
        expect(customer_with_jajin_pension.jajin.got).to eq(188.88 + amount)
      end

    end

    context "加金转赠失败" do

      let (:amount) { 88.88}

      before(:each) do
      end

      it "should raise error the jajin is not exist" do
        giver_log, given_log = GivenLog.add_both_given_log customer, customer_with_jajin_pension, amount
        expect(giver_log).not_to be_valid
        expect(giver_log.errors.full_messages).to be_include("转赠加金数额不能大于加金可用余额")
      end

    end

  end

end
