require 'rails_helper'

RSpec.describe "reward_logs/index", type: :view do
  before(:each) do
    assign(:reward_logs, [
      RewardLog.create!(
        :reward => nil,
        :customer => nil,
        :merchant => nil,
        :amount => "Amount",
        :float => "Float",
        :verify_code => "Verify Code"
      ),
      RewardLog.create!(
        :reward => nil,
        :customer => nil,
        :merchant => nil,
        :amount => "Amount",
        :float => "Float",
        :verify_code => "Verify Code"
      )
    ])
  end

  it "renders a list of reward_logs" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Amount".to_s, :count => 2
    assert_select "tr>td", :text => "Float".to_s, :count => 2
    assert_select "tr>td", :text => "Verify Code".to_s, :count => 2
  end
end
