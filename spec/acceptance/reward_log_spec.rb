require 'acceptance_helper'

resource "小金奖励" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "reward_logs/verify" do
    parameter :verify_code, "奖励码", required: true, scope: :reward_log

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    describe "success" do
      before do
        create(:customer_with_jajin_pension)
        @reward = create(:reward)
      end
      let(:verify_code) { @reward.verify_code }
      let(:raw_post) { params.to_json }

      example "成功领取小金奖励" do
        do_request
        expect(status).to eq(201)
      end
    end

    describe "fail" do
      before do
        create(:customer_with_jajin_pension)
      end
      let(:verify_code) { "000" }
      let(:raw_post) { params.to_json }

      example "成功领取小金奖励" do
        do_request
        expect(status).to eq(422)
      end
    end




  end


end