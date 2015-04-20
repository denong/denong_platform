require 'rails_helper'

RSpec.describe "gain_orgs/index", type: :view do
  before(:each) do
    assign(:gain_orgs, [
      GainOrg.create!(),
      GainOrg.create!()
    ])
  end

  it "renders a list of gain_orgs" do
    render
  end
end
