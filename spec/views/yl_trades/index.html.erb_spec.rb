require 'rails_helper'

RSpec.describe "yl_trades/index", type: :view do
  before(:each) do
    assign(:yl_trades, [
      YlTrade.create!(),
      YlTrade.create!()
    ])
  end

  it "renders a list of yl_trades" do
    render
  end
end
