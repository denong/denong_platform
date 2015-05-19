# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(
  email: "example@example.com",
  phone: "12345678901",
  password: "abcd.1234",
  sms_token: "989898",
  authentication_token: "qwertyuiop")

friend = User.create(
  email: "given_user@example.com",
  phone: "13888888888",
  password: "abcd.1234",
  sms_token: "989898",
  authentication_token: "qwertyuioq")

user.create_customer
user.customer.jajin.update_attributes got: 0, unverify: 88.88
user.customer.create_pension total: 88.88
user.customer.create_customer_reg_info name: "customer_name", id_card:  "333333333"

friend.create_customer
friend.customer.jajin.update_attributes got:188.88, unverify: 88.88
friend.customer.create_pension total: 8.88

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

merchant = Merchant.create ratio: 0.01
merchant.sys_reg_info = merchant_sys_reg_info

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
merchant.shops = shops
user.customer.follow! shops[0]
friend.customer.follow! shops[1]
user.customer.follow! shops[1]

tl_trades = []
(0..2).each do |i|
	tl_trades << TlTrade.create(
	card: "12345678",
	price: 888.88+i,
	phone: "12345678901")
end

merchant.tl_trades = tl_trades
user.customer.tl_trades = tl_trades

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

merchant.yl_trades = yl_trades
user.customer.yl_trades = yl_trades


merchant_image = Image.create(
  title: "image_title",
  photo: Rack::Test::UploadedFile.new('./spec/asset/news.png', 'image/png') )
tianhong_image = Image.create(
  title: "image_title",
  photo: Rack::Test::UploadedFile.new('./spec/asset/news.png', 'image/png') )
gonghang_image = Image.create(
  title: "image_title",
  photo: Rack::Test::UploadedFile.new('./spec/asset/news.png', 'image/png') )

merchant.thumb = merchant_image

bank_card = BankCard.create(
	bankcard_no: "0987654321123456",
	id_card: "333333333333333333",
	name: "ExampleName",
	phone: "12345678901",
	card_type: 1,
	bank: 1,
	bind_state: 1,
	bind_time: "2015-04-05 14:15:05")
user.customer.bank_cards << bank_card

identity_verify = IdentityVerify.create(
	name: "ExampleName",
	id_card: "333333333333333333",
	verify_state: 1)

gain_history = GainHistory.create(
	gain: 1.5,
	gain_date: "2015-04-09 16:24:06")

user.customer.gain_histories << gain_history

merchant_giving_log = MerchantGivingLog.create(
	amount: 1.5,
	giving_time: "2015-04-09 20:02:31")

user.customer.merchant_giving_logs << merchant_giving_log
merchant.merchant_giving_logs << merchant_giving_log

merchant_message = MerchantMessage.create(
	time: "2015-04-09 18:39:41",
	title: "MyString",
	content: "MyString",
	summary: "MyString",
	url: "MyString")

user.customer.merchant_messages << merchant_message
merchant.merchant_messages << merchant_message

exchange_log  = ExchangeLog.create( amount: 1.5)
given_log     = GivenLog.create( amount: 10)
member_card   = MemberCard.create( point: 100.88)

user.customer.exchange_logs << exchange_log
user.customer.member_cards << member_card
merchant.member_cards << member_card

gain_org_tianhong = GainOrg.create(
  title: "天弘基金",
  sub_title: "商家信息商家信息")

gain_org_gonghang = GainOrg.create(
  title: "工商银行",
  sub_title: "商家信息商家信息")

gain_org_tianhong.thumb = tianhong_image 
gain_org_gonghang.thumb = gonghang_image

gain_account_tianhong = GainAccount.create( total: 200.5 )
gain_account_gonghang = GainAccount.create( total: 100.5 )

user.customer.gain_accounts << gain_account_tianhong
user.customer.gain_accounts << gain_account_gonghang

gain_org_tianhong.gain_accounts << gain_account_tianhong
gain_org_gonghang.gain_accounts << gain_account_gonghang

merchant.tag_list.add "good"
merchant.save



topic = Topic.create(
  title: "test_title",
  subtitle: "subtitle",
  tags: ["good", "nice"])
