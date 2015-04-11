require 'rails_helper'

RSpec.describe "merchant_sys_reg_infos/index", type: :view do
  before(:each) do
    assign(:merchant_sys_reg_infos, [
      MerchantSysRegInfo.create!(),
      MerchantSysRegInfo.create!()
    ])
  end

  it "renders a list of merchant_sys_reg_infos" do
    render
  end
end
