# == Schema Information
#
# Table name: jajin_identity_codes
#
#  id              :integer          not null, primary key
#  expiration_time :datetime
#  merchant_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  amount          :float
#  verify_code     :string(255)
#  verify_state    :integer          default(0)
#  trade_time      :string(255)
#  company         :string(255)
#

require 'rails_helper'

RSpec.describe JajinIdentityCode, type: :model do
  it { should belong_to :merchant }

  let(:merchant)  { create(:merchant) }
  let(:expiration_time) { Time.zone.now + 1.day }

  describe "赠送小金码" do

    before(:each) do
      @jajin_identity_code = JajinIdentityCode.create(merchant: merchant, expiration_time: expiration_time, amount: 10.9)
    end

    it "should not to be nil for identity code" do
      expect(@jajin_identity_code.verify_code).not_to be_nil
    end

    it "should make the expiration_time after create time " do
      expect(@jajin_identity_code.expiration_time).to be > @jajin_identity_code.created_at
    end

    context "activate jajin identity code success" do
      it "should activate success" do
        expect(@jajin_identity_code.verify_state).to eq "unverified"
        expect(JajinIdentityCode.activate_by_verify_code @jajin_identity_code.verify_code).to be_present
        @jajin_identity_code.reload
        expect(@jajin_identity_code.verify_state).to eq "verified"
      end

      it "should activate success when the expiration_time is nil" do
        @jajin_identity_code.expiration_time = nil
        @jajin_identity_code.save
        expect(JajinIdentityCode.activate_by_verify_code @jajin_identity_code.verify_code).to be_present
      end
    end

    context "activate jajin identity code fail" do
      it "should fail when the verify code is not exist" do
        expect(JajinIdentityCode.activate_by_verify_code "111").to be_nil
      end

      it "should fail when the verfiy code is already verified" do
        expect(JajinIdentityCode.activate_by_verify_code @jajin_identity_code.verify_code).to be_present
        expect(JajinIdentityCode.activate_by_verify_code @jajin_identity_code.verify_code).to be_nil
      end

      it "should fail when the expiration_time is out" do
        @jajin_identity_code.expiration_time = DateTime.parse("2014-4-30")
        @jajin_identity_code.save
        expect(JajinIdentityCode.activate_by_verify_code @jajin_identity_code.verify_code).to be_nil
      end

    end


  end
end
