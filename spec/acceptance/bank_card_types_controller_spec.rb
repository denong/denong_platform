require 'acceptance_helper'

resource "银行" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/bank_card_types" do
    before(:each) do
      customer = create(:customer)

      banks = []
      banks << create(:bank, name:"招商银行", bank_card_amount: 2)
      banks << create(:bank, name:"工商银行", bank_card_amount: 3)
      banks << create(:bank, name:"上海银行", bank_card_amount: 4)

      bank_card_types = []
      bank_card_types << create(:bank_card_type, bank_name:"招商银行", bank_card_type: 0, bank: banks[0])
      bank_card_types << create(:bank_card_type, bank_name:"工商银行", bank_card_type: 0, bank: banks[1])
      bank_card_types << create(:bank_card_type, bank_name:"上海银行", bank_card_type: 0, bank: banks[2])
      bank_card_types << create(:bank_card_type, bank_name:"工商银行", bank_card_type: 1, bank: banks[1])
      bank_card_types << create(:bank_card_type, bank_name:"上海银行", bank_card_type: 1, bank: banks[2])

      BankCardType.reindex
      Sunspot.commit
      create(:bank_card, customer: customer, bank_name: "上海银行", bank_id: Bank.find_by_name("上海银行").id, bank_card_type: 0)
      create(:bank_card, customer: customer, bank_name: "招商银行", bank_id: Bank.first.id, bank_card_type: 0, stat_code: "00")
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :total_pages, "总页数"
    response_field :current_page, "页码"
    response_field :name, "银行名称"
    response_field :id, "银行id"
    response_field :bind_bank_card, "是否已经授权"
    response_field :logo, "银行logo"
    response_field :bank_card_amount, "已授权的银行卡数量"
    response_field :debit_card_amount, "已授权的储蓄卡数量"
    response_field :credit_card_amount, "已授权的信用卡数量"

    parameter :page, "页码", required: false
    parameter :bank_card_type, "银行卡类型(0:借记卡,1:信用卡)", required: true
    parameter :search, "搜索字段", required: false
    
    let(:search) { "商" }
    let(:bank_card_type) { 0 }
    let(:page) { 1 }

    example "根据银行卡类型搜索银行名称" do
      do_request
      puts "response is #{response_body}"
      expect(status).to eq(200)
    end

  end

end