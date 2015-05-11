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
    token = (0..9).to_a.sample(6).join

    # 发送短信
    if phone.present?
      company = "小确幸"
      ChinaSMS.use :yunpian, password: "6eba427ea91dab9558f1c5e7077d0a3e"
      result = ChinaSMS.to phone, {company: company, code: token}, {tpl_id: 2}
    end
    
    self.token = token
    self
  end

end
