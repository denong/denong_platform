require 'acceptance_helper'
resource "赠送加金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/given_logs" do
    before(:each) do
      @giver_customer = create(:customer_with_jajin_pension)
      friend = create(:friend)
      @given_customer = create(:customer_with_jajin_pension, user: friend)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :amount, "转赠数额", required: true, scope: :given_log
    parameter :giver_or_given_id, "赠与人id", required: true, scope: :given_log


    let(:amount) { 1 }
    let(:giver_or_given_id) { @given_customer.id }
    let(:raw_post) { params.to_json }

    example "加金转赠成功" do
      do_request
      expect(status).to eq(200)
    end

  end
end
