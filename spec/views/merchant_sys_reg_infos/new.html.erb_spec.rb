require 'rails_helper'

RSpec.describe "merchant_sys_reg_infos/new", type: :view do
  before(:each) do
    assign(:merchant_sys_reg_info, MerchantSysRegInfo.new())
  end

  it "renders new merchant_sys_reg_info form" do
    render

    assert_select "form[action=?][method=?]", merchant_sys_reg_infos_path, "post" do
    end
  end
end
