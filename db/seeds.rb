# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

jajin = Jajin.create( got:188.88, unverify: 88.88)
pension = Pension.create( total: 88.88)

customer_1 = Customer.create( jajin: jajin, pension: pension)
customer_2 = Customer.create( jajin: Jajin.create( got:0, unverify: 88.88), pension: Pension.create( total: 88.88))

user = User.create( 
    email: "example@example.com",
    phone: "12345678901",
    password: "abcd.1234",
    sms_token: "989898",
    authentication_token: "qwertyuiop",
    customer: customer_1)

friend = User.create(
  email: "given_user@example.com",
  phone: "13888888888",
  password: "abcd.1234",
  sms_token: "989898",
  authentication_token: "qwertyuioq",
  customer: customer_2)

merchant_sys_reg_info = MerchantSysRegInfo.create( 
	sys_name:       "merchant_sys_name",
    contact_person: "merchant_contact_person",
    contact_tel:    "09876543211",
    service_tel:    "11234567890",
    fax_tel:        "021-11111111",
    email:          "example@example.com",
    company_addr:   "shanghai",
    region:         "xuhui",
    industry:       "industry_name",
    postcode:       "200000",
    lon:            "31.10",
    lat:            "131.20",
    welcome_string: "welcome",
    comment_text:   "good")

shops = []
(0..2).each do |i|
	shops << Shop.create(
		name: "shop_name"+i.to_s,
		addr: "shop_addr"+i.to_s,
		contact_person: "shop_contact_person"+i.to_s,
		contact_tel: "12345678901",
		work_time: "9:00-18:00",
		lon: 120.51+i,
		lat: 30.40+i)
end

tl_trades = []
(0..2).each do |i|
	tl_trades << TlTrade.create(
	card: "12345678",
	price: 888.88+i,
	phone: "12345678901")
end

yl_trades = []
(0..2).each do |i|
	yl_trades << YlTrade.create(
		trade_time: "2015-04-09 17:13:03",
		log_time: "2015-04-09",
		trade_currency: "MyString",
		trade_state: "MyString",
		gain: 1.5+i,
		expend: 1.5+i,
		merchant_ind: "MyString",
		pos_ind: "MyString",
		merchant_name: "MyString",
		merchant_type: "MyString",
		merchant_city: "MyString",
		trade_type: "MyString",
		trade_way: "MyString",
		merchant_addr: "MyString",
		card: "123456789")
end

image = Image.create(
  title: "image_title",
  photo: Rack::Test::UploadedFile.new('./spec/asset/news.png', 'image/png') )

merchant = Merchant.create( ratio: 0.01,shops: shops, tl_trades: tl_trades, yl_trades: yl_trades)
merchant.sys_reg_info = merchant_sys_reg_info

bank_card = BankCard.create(
	bankcard_no: "0987654321123456",
	id_card: "333333333333333333",
	name: "ExampleName",
	phone: "12345678901",
	card_type: 1,
	bank: 1,
	bind_state: 1,
	bind_time: "2015-04-05 14:15:05")

identity_verify = IdentityVerify.create(
	name: "ExampleName",
	id_card: "333333333333333333",
	verify_state: 1)

gain_history = GainHistory.create(
	gain: 1.5,
	gain_date: "2015-04-09 16:24:06")



merchant_giving_log = MerchantGivingLog.create(
	amount: 1.5,
	giving_time: "2015-04-09 20:02:31")

merchant_message = MerchantMessage.create(
	time: "2015-04-09 18:39:41",
	title: "MyString",
	content: "MyString",
	summary: "MyString",
	url: "MyString")


exchange_log = ExchangeLog.create(
	amount: 1.5)

given_log = GivenLog.create(
	amount: 10)

customer_reg_info = CustomerRegInfo.create(
	name:    "customer_name",
	id_card:  "333333333")

member_card = MemberCard.create(
	point: 100.88)

gain_account_tianhong = GainAccount.create(
  total: 200.5 )
gain_account_gonghang = GainAccount.create(
  total: 100.5 )

gain_org_tianhong = GainOrg.create(
  title: "天弘基金",
  sub_title: "商家信息商家信息",
  thumb: image
  )

gain_org_gonghang = GainOrg.create(
  title: "工商银行",
  sub_title: "商家信息商家信息",
  thumb: image
  )




