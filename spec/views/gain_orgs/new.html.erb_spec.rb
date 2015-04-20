require 'rails_helper'

RSpec.describe "gain_orgs/new", type: :view do
  before(:each) do
    assign(:gain_org, GainOrg.new())
  end

  it "renders new gain_org form" do
    render

    assert_select "form[action=?][method=?]", gain_orgs_path, "post" do
    end
  end
end
