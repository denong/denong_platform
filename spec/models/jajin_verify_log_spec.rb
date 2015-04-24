# == Schema Information
#
# Table name: jajin_verify_logs
#
#  id          :integer          not null, primary key
#  amount      :float
#  verify_code :string(255)
#  verify_time :datetime
#  customer_id :integer
#  merchant_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe JajinVerifyLog, type: :model do
  it { should belong_to :customer }
  it { should belong_to :merchant }

  describe "扫码赠送加金" do

    let(:customer)  { create(:customer_with_jajin_pension) }
    let(:merchant)  { create(:merchant) }
    let(:expiration_time) { DateTime.new(2021,2,3,4,5,6,'+8') }

    context "扫码赠送加金成功" do
      before(:each) do
        @jajin_identity_code = JajinIdentityCode.create(merchant: merchant, expiration_time: expiration_time, amount: 10)
        @expectation = expect{ create(:jajin_verify_log, verify_code: @jajin_identity_code[:verify_code], customer: customer, amount: 10) }
      end

      it "should be success for add verify code" do
        @expectation.to change{ JajinVerifyLog.count }.by 1
      end

      it "should add customer's jajin by amount" do
        @expectation.to change{ customer.jajin.got }.by @jajin_identity_code.amount
      end
    end

    context "扫码赠送加金失败" do
      before(:each) do
        @jajin_identity_code = JajinIdentityCode.create(merchant: merchant, expiration_time: expiration_time, amount: 10)
      end

      it "should be failed because of the invalid code" do
        jajin_verify_log = build(:jajin_verify_log, verify_code: "000", customer: customer, amount: 10) 
        expect(jajin_verify_log).not_to be_valid
        expect(jajin_verify_log.errors.full_messages).to be_include("提示：该加金验证码不存在或已失效")
      end

      it "should be failed because of the verify code is expired" do
        @jajin_identity_code.update_attributes expiration_time: Time.zone.now - 1.day
        jajin_verify_log = build(:jajin_verify_log, verify_code: @jajin_identity_code[:verify_code], customer: customer, amount: 10) 
        expect(jajin_verify_log).not_to be_valid
        expect(jajin_verify_log.errors.full_messages).to be_include("提示：该加金验证码不存在或已失效")
      end
    end


  end
end
