require 'rails_helper'

RSpec.describe "GainOrgs", type: :request do
  describe "GET /gain_orgs" do
    it "works! (now write some real specs)" do
      get gain_orgs_path
      expect(response).to have_http_status(200)
    end
  end
end
