require 'rails_helper'

RSpec.describe "gain_orgs/show", type: :view do
  before(:each) do
    @gain_org = assign(:gain_org, GainOrg.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
