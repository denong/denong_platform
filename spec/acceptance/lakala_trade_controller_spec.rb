require 'acceptance_helper'

resource "代理商" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/lakala_trades" do

    def generate_sign
      origin = {}
      origin[:phone] = "17749725507"
      origin[:card] = "6214AAAAAAAA9161"
      origin[:price] = 100
      origin[:pos_ind] = "pi123456"
      origin[:shop_ind] = "si123456"
      origin[:trade_ind] = "ti123456"
      origin[:trade_time] = "20150801142903"

      params_array = []
      origin.to_a.each do |par_info|
        params_array << par_info.join
      end
      params_array.sort!
      sign_string = params_array.join
      string = EncryptRsa.encode sign_string, "key/lakala/private_key.pem"
      string
    end

    parameter :phone, "电话号码", required: true
    parameter :card, "银行卡号", required: true
    parameter :price, "消费金额", required: true
    parameter :pos_ind, "POS机编号", required: true
    parameter :shop_ind, "商户编号", required: true
    parameter :trade_ind, "交易流水号", required: true
    parameter :trade_time, "交易时间", required: true
    parameter :sign, "签名认证", required: true

    let(:phone) { "17749725507" }
    let(:card) { "6214AAAAAAAA9161" }
    let(:price) { 100 }
    let(:pos_ind) { "pi123456" }
    let(:shop_ind) { "si123456" }
    let(:trade_ind) { "ti123456" }
    let(:trade_time) { "20150801142903" }
    let(:sign) { generate_sign }
    let(:raw_post) { params.to_json }

    response_field :error_code, "错误码"
    response_field :reason, "错误原因"

    example "拉卡拉交易记录" do
      do_request
      expect(status).to eq(200)
    end
  end
end