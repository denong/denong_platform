require 'rails_helper'

RSpec.describe "merchant_sys_reg_infos/show", type: :view do
  before(:each) do
    @merchant_sys_reg_info = assign(:merchant_sys_reg_info, MerchantSysRegInfo.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
