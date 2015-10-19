class TextMessage

  # 企业代码  用户ID  密码  企业签名  适用范围
  # dnwl  80560   dnwl2015  【CCPP合格计划】  触发类短信
  # dlwl66  80508   dlwl66    【小确幸】 触发类短信 (一般用这个) （功能）
  # dlwl  805081  dnxfyl    【小确幸】 会员短信 （营销）
  # enum content_type: { ccpp: 0, xqx: 1, xqx_member: 2 }

  # dnwl  80560
  # expid: 
  
  # dlwl  80508 
  # expid: 短信随机码: 1; 用户注册: 2; 指定的短信: 3

  # dlwl  805081
  # expid: 
    
  # TextMessage.send_cancel_msg phone, 3
  def self.send_cancel_msg phone, expid
    content = "亲爱的用户，您的“小确幸”账号已被注销。如有任何问题，可咨询微信公众号“CCPP消费养老”。祝您生活愉快，工作顺利！"
    send_msg 1, content, phone, expid
  end

  def self.send_msg content_type, content, phone, expid

    # uid: u_id, auth: md5, mobile: phone, msg: msg, expid: 0, encode: msg.encoding
    params = {}
    params[:auth], params[:uid] = (get_auth content_type)
    params[:mobile] = phone
    params[:msg] = content
    params[:expid] = expid    # 用于扩展手机号，标识发送的短信内容
    params[:encode] = content.encoding  
    
    response = RestClient.get "http://sms.10690221.com:9011/hy/", {params: params}
  end
  
  def self.get_auth content_type
       
    case content_type
    when 0
      company_id = "dnwl"
      password = "dnwl2015"
      u_id = 80560
    when 1
      company_id = "dlwl"
      password = "dlwl66"
      u_id = 80508
    when 2
      company_id = "dlwl"
      password = "dnxfyl"
      u_id = 805081
    end
    
    md5 = Digest::MD5.new
    auth = md5.update company_id+password
    return auth, u_id
  end
end
