require 'rails_helper'

RSpec.describe "yl_trades/new", type: :view do
  before(:each) do
    assign(:yl_trade, YlTrade.new())
  end

  it "renders new yl_trade form" do
    render

    assert_select "form[action=?][method=?]", yl_trades_path, "post" do
    end
  end
end
