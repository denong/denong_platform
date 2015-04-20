require 'rails_helper'

RSpec.describe "gain_orgs/edit", type: :view do
  before(:each) do
    @gain_org = assign(:gain_org, GainOrg.create!())
  end

  it "renders the edit gain_org form" do
    render

    assert_select "form[action=?][method=?]", gain_org_path(@gain_org), "post" do
    end
  end
end
