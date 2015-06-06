require 'rails_helper'

RSpec.describe "reward_logs/show", type: :view do
  before(:each) do
    @reward_log = assign(:reward_log, RewardLog.create!(
      :reward => nil,
      :customer => nil,
      :merchant => nil,
      :amount => "Amount",
      :float => "Float",
      :verify_code => "Verify Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Amount/)
    expect(rendered).to match(/Float/)
    expect(rendered).to match(/Verify Code/)
  end
end
