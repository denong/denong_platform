require 'acceptance_helper'

resource "获取投资机构收益列表" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/gain_accounts" do
    user_attrs = FactoryGirl.attributes_for :user

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :gain_org_thumb, "消费机构图片url"
    response_field :gain_org_title, "消费机构标题"
    response_field :gain_org_sub_title, "消费机构副标题"
    response_field :gain_total, "该用户在这个消费机构的收益总和"

    example "获取收益列表成功" do
      customer = create :customer
      create :gain_account_tianhong, customer: customer
      create :gain_account_gonghang, customer: customer
      do_request
      expect(status).to eq(200)
    end

  end

end