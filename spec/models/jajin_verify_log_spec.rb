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
        @jajin_identity_code = JajinIdentityCode.add_identity_code(customer: customer, merchant: merchant, expiration_time: expiration_time)
      end

      it "should be success for add verify code" do
        expect(JajinVerifyLog.create())
      end

      it "should make the expiration_time after create time " do
        expect(@jajin_identity_code.expiration_time).to be > @jajin_identity_code.created_at
      end

    end



  end
end
