require 'rails_helper'

RSpec.describe "MerchantSysRegInfos", type: :request do
  describe "GET /merchant_sys_reg_infos" do
    it "works! (now write some real specs)" do
      get merchant_sys_reg_infos_path
      expect(response).to have_http_status(200)
    end
  end
end
