require 'rails_helper'

RSpec.describe "tl_trades/show", type: :view do
  before(:each) do
    @tl_trade = assign(:tl_trade, TlTrade.create!(
      :phone => "Phone",
      :card => "Card",
      :price => 1.5,
      :pos_ind => "Pos Ind",
      :shop_ind => "Shop Ind",
      :trade_ind => "Trade Ind"
    ))
  end

  # it "renders attributes in <p>" do
  #   render
  #   expect(rendered).to match(/Phone/)
  #   expect(rendered).to match(/Card/)
  #   expect(rendered).to match(/1.5/)
  #   expect(rendered).to match(/Pos Ind/)
  #   expect(rendered).to match(/Shop Ind/)
  #   expect(rendered).to match(/Trade Ind/)
  # end
end
