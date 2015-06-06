require 'rails_helper'

RSpec.describe "reward_logs/edit", type: :view do
  before(:each) do
    @reward_log = assign(:reward_log, RewardLog.create!(
      :reward => nil,
      :customer => nil,
      :merchant => nil,
      :amount => "MyString",
      :float => "MyString",
      :verify_code => "MyString"
    ))
  end

  it "renders the edit reward_log form" do
    render

    assert_select "form[action=?][method=?]", reward_log_path(@reward_log), "post" do

      assert_select "input#reward_log_reward_id[name=?]", "reward_log[reward_id]"

      assert_select "input#reward_log_customer_id[name=?]", "reward_log[customer_id]"

      assert_select "input#reward_log_merchant_id[name=?]", "reward_log[merchant_id]"

      assert_select "input#reward_log_amount[name=?]", "reward_log[amount]"

      assert_select "input#reward_log_float[name=?]", "reward_log[float]"

      assert_select "input#reward_log_verify_code[name=?]", "reward_log[verify_code]"
    end
  end
end
