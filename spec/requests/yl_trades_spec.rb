require 'rails_helper'

RSpec.describe "YlTrades", type: :request do
  describe "GET /yl_trades" do
    it "works! (now write some real specs)" do
      get yl_trades_path
      expect(response).to have_http_status(200)
    end
  end
end
