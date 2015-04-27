# == Schema Information
#
# Table name: identity_verifies
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  verify_state :integer
#  customer_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#  id_card      :string(255)
#

require 'rails_helper'

RSpec.describe IdentityVerify, type: :model do
  it { should belong_to :customer }

  context "relate with customer reg info" do
    before(:each) do
      @customer = create(:customer_with_raw_reg_info)
      image = create(:image)
      @identify = create(:identity_verify, customer: @customer, front_image: image, back_image: image)
    end

    it "should be wait_verify" do
      expect(@identify.verify_state).to eq("wait_verify")
      expect(@customer.customer_reg_info.verify_state).to eq("wait_verify")
    end

    it "should reject right" do
      @identify.reject!
      @identify.reload
      @customer.reload
      expect(@identify.verify_state).to eq("verified_fail")
      expect(@customer.customer_reg_info.verify_state).to eq("verified_fail")
    end

    it "should accept right" do
      @identify.accept!
      @identify.reload
      @customer.reload
      expect(@identify.verify_state).to eq("verified")
      expect(@customer.customer_reg_info.verify_state).to eq("verified")
    end
  end

end
