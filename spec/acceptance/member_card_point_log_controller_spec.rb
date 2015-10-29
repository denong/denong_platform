require 'acceptance_helper'

resource "积分转小金记录" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/member_card_point_log" do
    before do
      create(:user)
      merchant = create(:merchant)
      merchant_customer = create(:merchant_customer)
      create(:personal_info, name: "于子洵", id_card: "333333333333333333", result: 0)
      @member_card = create(:member_card, merchant: merchant, user_name: "于子洵", passwd:"333333333333333333")
    end

    let(:id) { MemberCard.all.last.id }
    parameter :member_card_id, "会员卡ID", required: true
    parameter :point, "要兑换的积分分值", required: true

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :member_card_id, "会员卡ID"
    response_field :pension, "养老金"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:member_card_id) { @member_card.id }
    let(:point) { -50 }
    let(:raw_post) { params.to_json }

    example "会员卡积分转小金成功" do
      do_request
      expect(status).to eq 200
    end
  end
  
  post "/member_card_point_log" do
    before do
      agent = create(:agent)
      user = create(:user)
      merchant = create(:merchant, agent: agent)
      create(:personal_info, name: "于子洵", id_card: "333333333333333333", result: 0)
      @member_card = create(:member_card, merchant: merchant, user_name: "于子洵", passwd:"333333333333333333", customer: user.customer)
      create(:member_card_point_log, unique_ind: "123456", customer: user.customer, member_card: @member_card, point: -10)
    end

    parameter :point, "要兑换的积分分值", required: true, scope: :member_card_point_log 
    parameter :member_card_id, "会员卡ID", required: true, scope: :member_card_point_log 
    parameter :unique_ind, "商户兑换记录的唯一标示", required: true, scope: :member_card_point_log 
    parameter :first_time, "用户是否第一次注册", required: true, scope: :member_card_point_log 

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :member_card_id, "会员卡ID"
    response_field :pension, "养老金"

    user_attrs = FactoryGirl.attributes_for(:agent)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    let(:member_card_id) { @member_card.id }
    let(:unique_ind) { "1234567" }
    let(:point) { -50 }
    let(:first_time) { true }
    let(:raw_post) { params.to_json }

    example "代理商会员卡积分转小金成功" do
      do_request
      # puts "response is #{response_body}"
      expect(status).to eq 200
    end
  end

  get "/member_card_point_log" do
    before do
      merchant = create(:merchant)
      customer = create(:customer_with_jajin_pension)
      user = create(:user, phone: "12345654321", email: "abcd@abcd.com", authentication_token: "lllll")

      merchant_customers = []
      merchant_customers << create(:merchant_customer)
      merchant_customers << create(:merchant_customer, u_id: "77777777")

      create(:personal_info, name: "A1", id_card: "111111111111111111", result: 0)
      create(:personal_info, name: "A2", id_card: "222222222222222222", result: 0)

      member_cards = []
      member_cards << create(:member_card, customer: customer, merchant: merchant, user_name: "A2", passwd: "222222222222222222", )
      member_cards << create(:member_card, user_name: "A1", passwd: "111111111111111111", customer: user.customer, merchant: merchant)

      member_cards.each do |member_card|
        create(:member_card_point_log, member_card: member_card, point: -100, customer: customer, unique_ind: member_cards.index(member_card).to_s)
      end
    end

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"
    response_field :pension, "养老金"
    response_field :log_num, "记录总数"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :page, "页码", required: false

    example "用户获取积分转小金全部记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/member_card_point_log" do
    before do
      merchant_user = create(:merchant_user)
      merchant_user1 = create(:merchant_user, email: "merchant_user1@example.com", phone: "12345678904", authentication_token: "pwertyuiop")

      merchant = create(:merchant, merchant_user: merchant_user)
      merchant1 = create(:merchant, merchant_user: merchant_user1)
      customer = create(:customer_with_reg_info_jaiin_pension)

      merchant_customers = []
      merchant_customers << create(:merchant_customer)
      merchant_customers << create(:merchant_customer, u_id: "77777777")

      create(:personal_info, name: "A1", id_card: "111111111111111111", result: 0)
      create(:personal_info, name: "A2", id_card: "222222222222222222", result: 0)

      member_cards = []
      member_cards << create(:member_card, customer: customer, merchant: merchant, user_name: "A2", passwd: "222222222222222222", )
      member_cards << create(:member_card, user_name: "A1", passwd: "111111111111111111", customer: customer, merchant: merchant1)

      member_cards.each do |member_card|
        member_card_point_log = create(:member_card_point_log, member_card: member_card, point: -100, customer: customer, unique_ind: member_cards.index(member_card).to_s)
      end
    end

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"
    response_field :pension, "养老金"
    response_field :log_num, "记录总数"

    merchant_attrs = FactoryGirl.attributes_for(:merchant_user)

    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    parameter :page, "页码", required: false
    parameter :phone, "用户手机号", required: true, scope: :member_card_point_log 
    parameter :begin_time, "开始时间", required: false, scope: :member_card_point_log
    parameter :end_time, "结束时间", required: false, scope: :member_card_point_log

    let(:phone) { "12345678903" }
    let(:begin_time) { DateTime.new(2015,8,1)  }
    let(:end_time) { DateTime.new(2016,8,1)  }
    let(:raw_post) { params.to_json }

    example "商户获取积分转小金全部记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/member_card_point_log" do
    before do
      agent = create(:agent)
      merchant_user = create(:merchant_user)
      merchant_user1 = create(:merchant_user, email: "merchant_user1@example.com", phone: "12345678904", authentication_token: "pwertyuiop")

      merchant = create(:merchant, merchant_user: merchant_user)
      merchant1 = create(:merchant, merchant_user: merchant_user1)

      agent.merchants << merchant
      # agent.merchants << merchant1

      customer = create(:customer_with_reg_info_jaiin_pension)

      merchant_customers = []
      merchant_customers << create(:merchant_customer)
      merchant_customers << create(:merchant_customer, u_id: "77777777")

      create(:personal_info, name: "A1", id_card: "111111111111111111", result: 0)
      create(:personal_info, name: "A2", id_card: "222222222222222222", result: 0)

      member_cards = []
      member_cards << create(:member_card, customer: customer, merchant: merchant, user_name: "A2", passwd: "222222222222222222", )
      member_cards << create(:member_card, user_name: "A1", passwd: "111111111111111111", customer: customer, merchant: merchant1)

      member_cards.each do |member_card|
        member_card_point_log = create(:member_card_point_log, member_card: member_card, point: -100, customer: customer, unique_ind: member_cards.index(member_card).to_s)
      end
    end

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"
    response_field :pension, "养老金"
    response_field :log_num, "记录总数"

    merchant_attrs = FactoryGirl.attributes_for(:agent)

    header "X-User-Token", merchant_attrs[:authentication_token]
    header "X-User-Phone", merchant_attrs[:phone]

    parameter :page, "页码", required: false
    parameter :phone, "用户手机号", required: true, scope: :member_card_point_log 
    parameter :begin_time, "开始时间", required: true, scope: :member_card_point_log
    parameter :end_time, "结束时间", required: true, scope: :member_card_point_log

    let(:phone) { "12345678903" }
    let(:begin_time) { DateTime.new(2015,8,1)  }
    let(:end_time) { DateTime.new(2016,8,1)  }
    let(:raw_post) { params.to_json }

    example "代理商获取积分转小金全部记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/member_card_point_log" do
    before do
      merchant = create(:merchant)
      customer = create(:customer_with_jajin_pension)
      user = create(:user, phone: "12345654321", email: "abcd@abcd.com", authentication_token: "lllll")

      merchant_customers = []
      merchant_customers << create(:merchant_customer, merchant: merchant)
      merchant_customers << create(:merchant_customer, u_id: "77777777", merchant: merchant)

      create(:personal_info, name: "A1", id_card: "111111111111111111", result: 0)
      create(:personal_info, name: "A2", id_card: "222222222222222222", result: 0)

      member_cards = []
      member_cards << create(:member_card, customer: customer, merchant: merchant, user_name: "A2", passwd: "222222222222222222", )
      member_cards << create(:member_card, user_name: "A1", passwd: "111111111111111111", customer: user.customer, merchant: merchant)

      member_cards.each do |member_card|
        (0..1).each do |index|
          create(:member_card_point_log, member_card: member_card, point: -50, customer: customer, unique_ind: member_cards.index(member_card).to_s << index.to_s)
        end
      end
    end

    let(:member_card_id) { MemberCard.last.id }

    parameter :page, "页码", required: false
    parameter :member_card_id, "会员卡ID", required: true

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"
    response_field :pension, "养老金"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取单张积分卡的积分转小金记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

  get "/member_card_point_log/:id" do
    before do
      merchant = create(:merchant)
      customer = create(:customer_with_jajin_pension)
      user = create(:user, phone: "12345654321", email: "abcd@abcd.com", authentication_token: "lllll")

      merchant_customers = []
      merchant_customers << create(:merchant_customer, merchant: merchant)
      merchant_customers << create(:merchant_customer, u_id: "77777777", merchant: merchant)

      create(:personal_info, name: "A1", id_card: "111111111111111111", result: 0)
      create(:personal_info, name: "A2", id_card: "222222222222222222", result: 0)

      member_cards = []
      member_cards << create(:member_card, customer: customer, merchant: merchant, user_name: "A2", passwd: "222222222222222222", )
      member_cards << create(:member_card, user_name: "A1", passwd: "111111111111111111", customer: user.customer, merchant: merchant)

      member_cards.each do |member_card|
        puts ""
        create(:member_card_point_log, member_card: member_card, point: -100, customer: customer, unique_ind: member_cards.index(member_card).to_s)
      end
    end

    let(:id) { MemberCardPointLog.last.id }

    parameter :member_card_id, "会员卡ID", required: true

    response_field :point, "积分分值"
    response_field :jajin, "小金数"
    response_field :created_at, "兑换时间"
    response_field :member_card_id, "会员卡ID"
    response_field :pension, "养老金"
    response_field :unique_ind, "商户兑换记录的唯一标示"

    user_attrs = FactoryGirl.attributes_for(:user)

    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    example "获取一条积分转小金记录成功" do
      do_request
      expect(status).to eq 200
    end
  end

  post "/point_log" do
    before do
      @user = create(:user, phone: "13316107607")
      @merchant = create(:merchant)
      merchant_user = create(:merchant_user, merchant: @merchant)
      merchant_customer = create(:merchant_customer)
      create(:personal_info, name: "张三", id_card: "333333333333333333", result: 0)
      member_card = create(:member_card, customer: @user.customer, merchant: @merchant, user_name: "张三", passwd: "333333333333333333")
      create(:member_card_point_log, unique_ind: "abcd", member_card: member_card, point: -1, customer: @user.customer)
    end

    def generate_params 
      origin = {}
      origin[:api_key] = attributes_for(:merchant_user)[:api_key]
      origin[:id_card] = "333333333333333333"
      origin[:name] = "张三"
      origin[:phone] = "13316107607"
      origin[:point] = 100
      origin[:unique_ind] = "abcd"
      origin[:timestamp] = 20150801142903

      params_array = []
      origin.to_a.each do |par_info|
        params_array << par_info.join
      end
      params_array.sort!
      sign_string = params_array.join
      puts "sign_string is #{sign_string}"
      string = EncryptRsa.encode sign_string, "key/guangdong_telecom/private_key.pem"
      string
    end

    parameter :api_key, "商户的唯一编号", required: true
    parameter :id_card, "用户身份证号码", required: true
    parameter :name, "用户姓名", required: true
    parameter :phone, "用户手机号码", required: true
    parameter :point, "积分分值", required: true
    parameter :unique_ind, "流水号（交易的唯一标示）", required: true
    parameter :sign, "签名认证", required: true
    parameter :timestamp, "时间戳", required: true

    response_field :error_code, "错误码"
    response_field :reason, "错误原因"

    let(:api_key) { @merchant.merchant_user.api_key }
    let(:id_card) { "333333333333333333" }
    let(:name) { "张三" }
    let(:phone) { 13316107607 }
    let(:point) { 100 }
    let(:unique_ind) { "abcd" }
    let(:timestamp) { "20150801142903" }
    let(:sign) { generate_params }
    let(:raw_post) { params.to_json }

    example "Open API接口" do
      do_request
      puts "response is #{response_body}"
      expect(status).to eq 200
    end
  end

end