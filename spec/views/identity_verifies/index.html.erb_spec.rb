require 'rails_helper'

RSpec.describe "identity_verifies/index", type: :view do
  before(:each) do
    assign(:identity_verifies, [
      IdentityVerify.create!(),
      IdentityVerify.create!()
    ])
  end

  it "renders a list of identity_verifies" do

  end
end
