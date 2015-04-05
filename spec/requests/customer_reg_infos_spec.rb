require 'rails_helper'

RSpec.describe "CustomerRegInfos", type: :request do
  describe "GET /customer_reg_infos" do
    it "works! (now write some real specs)" do
      get customer_reg_infos_path
      expect(response).to have_http_status(200)
    end
  end
end
