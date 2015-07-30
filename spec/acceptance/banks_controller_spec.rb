require 'acceptance_helper'

resource "银行" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/banks" do
    before(:each) do
      customer = create(:customer)

      banks = []
      banks << create(:bank, name:"招商银行")
      banks << create(:bank, name:"工商银行")
      banks << create(:bank, name:"上海银行")
      banks.each do |bank|
        bank.index!
      end
      Sunspot.commit
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :name, "银行名称"

    parameter :page, "页码", required: false
    parameter :search, "搜索字段", required: false
    let(:search) { "商" }
    let(:page) { 1 }

    example "搜索银行名称" do
      do_request
      puts "response is #{response_body}"
      expect(status).to eq(200)
    end

  end

end