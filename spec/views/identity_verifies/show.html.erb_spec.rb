require 'rails_helper'

RSpec.describe "identity_verifies/show", type: :view do
  before(:each) do
    @identity_verify = assign(:identity_verify, IdentityVerify.create!())
  end

  it "renders attributes in <p>" do

  end
end
