require 'rails_helper'

RSpec.describe "identity_verifies/new", type: :view do
  before(:each) do
    assign(:identity_verify, IdentityVerify.new())
  end

  it "renders new identity_verify form" do

  end
end
