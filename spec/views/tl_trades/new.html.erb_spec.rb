require 'rails_helper'

RSpec.describe "tl_trades/new", type: :view do
  before(:each) do
    assign(:tl_trade, TlTrade.new(
      :phone => "MyString",
      :card => "MyString",
      :price => 1.5,
      :pos_ind => "MyString",
      :shop_ind => "MyString",
      :trade_ind => "MyString"
    ))
  end

  it "renders new tl_trade form" do
    render

    assert_select "form[action=?][method=?]", tl_trades_path, "post" do

      assert_select "input#tl_trade_phone[name=?]", "tl_trade[phone]"

      assert_select "input#tl_trade_card[name=?]", "tl_trade[card]"

      assert_select "input#tl_trade_price[name=?]", "tl_trade[price]"

      assert_select "input#tl_trade_pos_ind[name=?]", "tl_trade[pos_ind]"

      assert_select "input#tl_trade_shop_ind[name=?]", "tl_trade[shop_ind]"

      assert_select "input#tl_trade_trade_ind[name=?]", "tl_trade[trade_ind]"
    end
  end
end
