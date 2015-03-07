require 'rails_helper'

RSpec.describe "tl_trades/index", type: :view do
  before(:each) do
    assign(:tl_trades, [
      TlTrade.create!(
        :phone => "Phone",
        :card => "Card",
        :price => 1.5,
        :pos_ind => "Pos Ind",
        :shop_ind => "Shop Ind",
        :trade_ind => "Trade Ind"
      ),
      TlTrade.create!(
        :phone => "Phone",
        :card => "Card",
        :price => 1.5,
        :pos_ind => "Pos Ind",
        :shop_ind => "Shop Ind",
        :trade_ind => "Trade Ind"
      )
    ])
  end

  it "renders a list of tl_trades" do
    render
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Card".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Pos Ind".to_s, :count => 2
    assert_select "tr>td", :text => "Shop Ind".to_s, :count => 2
    assert_select "tr>td", :text => "Trade Ind".to_s, :count => 2
  end
end
