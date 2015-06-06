require 'rails_helper'

RSpec.describe "RewardLogs", type: :request do
  describe "GET /reward_logs" do
    it "works! (now write some real specs)" do
      get reward_logs_path
      expect(response).to have_http_status(200)
    end
  end
end
