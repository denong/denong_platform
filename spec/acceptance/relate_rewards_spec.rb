require 'acceptance_helper'

resource "活动送小金" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "relate_rewards" do
    parameter :verify_code, "奖励码", required: true
    parameter :phone, "电话号码", required: true

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    before do
      create(:customer_with_jajin_pension)
      @reward = create(:reward)
    end
    let(:verify_code) { @reward.verify_code }
    let(:phone) { user_attrs[:phone] }
    let(:raw_post) { params.to_json }

    example "记录创建" do
      do_request
      expect(status).to eq(200)
    end
  end

end
