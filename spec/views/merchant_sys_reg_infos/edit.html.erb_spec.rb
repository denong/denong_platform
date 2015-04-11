require 'rails_helper'

RSpec.describe "merchant_sys_reg_infos/edit", type: :view do
  before(:each) do
    @merchant_sys_reg_info = assign(:merchant_sys_reg_info, MerchantSysRegInfo.create!())
  end

  it "renders the edit merchant_sys_reg_info form" do
    render

    assert_select "form[action=?][method=?]", merchant_sys_reg_info_path(@merchant_sys_reg_info), "post" do
    end
  end
end
