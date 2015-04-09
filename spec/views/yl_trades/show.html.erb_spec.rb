require 'rails_helper'

RSpec.describe "yl_trades/show", type: :view do
  before(:each) do
    @yl_trade = assign(:yl_trade, YlTrade.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
