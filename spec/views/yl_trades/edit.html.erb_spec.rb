require 'rails_helper'

RSpec.describe "yl_trades/edit", type: :view do
  before(:each) do
    @yl_trade = assign(:yl_trade, YlTrade.create!())
  end

  it "renders the edit yl_trade form" do
    render

    assert_select "form[action=?][method=?]", yl_trade_path(@yl_trade), "post" do
    end
  end
end
