# == Schema Information
#
# Table name: jajin_identity_codes
#
#  id              :integer          not null, primary key
#  expiration_time :datetime
#  customer_id     :integer
#  merchant_id     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  amount          :float
#  verify_code     :string(255)
#

require 'rails_helper'

RSpec.describe JajinIdentityCode, type: :model do
  it { should belong_to :customer }
  it { should belong_to :merchant }

  let(:customer)  { create(:customer_with_jajin_pension) }
  let(:merchant)  { create(:merchant) }
  let(:expiration_time) { DateTime.new(2021,2,3,4,5,6,'+8') }
  describe "赠送加金码" do
    before(:each) do
      @jajin_identity_code = JajinIdentityCode.add_identity_code(customer: customer, merchant: merchant, expiration_time: expiration_time)
    end

    it "should not to be nil for identity code" do
      expect(@jajin_identity_code.verify_code).not_to be_nil
    end

    it "should make the expiration_time after create time " do
      expect(@jajin_identity_code.expiration_time).to be > @jajin_identity_code.created_at
    end
  end
end
