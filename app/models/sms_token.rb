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
  def activate!
    token = (0..9).to_a.sample(4).join

    # 发送短信
    if phone.present?
      #【德浓消费养老】您的验证码是3019。如非本人操作，请忽略本短信
      # company = "德浓消费养老"
      # ChinaSMS.use :yunpian, password: "6eba427ea91dab9558f1c5e7077d0a3e"
      # result = ChinaSMS.to phone, {company: company, code: token}, {tpl_id: 2}

      # 验证码短信， 签名为 小确幸， 触发类短信。
      content = "您的验证码是#{token}。如非本人操作，请忽略本短信"
      TextMessage.send_msg 1, content, phone, 1

    end
    
    self.token = token
    self
  end

end

