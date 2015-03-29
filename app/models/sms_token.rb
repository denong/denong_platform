# == Schema Information
#
# Table name: sms_tokens
#
#  id         :integer          not null, primary key
#  phone      :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SmsToken < ActiveRecord::Base
  def activate
    token = (0..9).to_a.sample(6).join

    # 发送短信
    company = "加金宝"
    ChinaSMS.use :yunpian, password: "e480d5b2daedcd3c0b0d83438ffa01b8"
    result = ChinaSMS.to @sms_token.phone, {company: company, code: token}, {tpl_id: 2}

    self.token = token
    self
  end
end
