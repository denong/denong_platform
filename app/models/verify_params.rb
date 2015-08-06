class VerifyParams
  attr_accessor :api_name, :bp_id, :api_key, :bp_order_id, :user_name, :cert_type, :cert_no, :card_no, :user_mobile

  def initialize

  end

  def as_json(options=nil)
    {
      api_name: api_name,
      bp_id: bp_id,
      bp_order_id: bp_order_id,
      api_key: api_key,
      user_name: user_name,
      cert_type: cert_type,
      cert_no: cert_no,
      card_no: card_no,
      user_mobile: user_mobile
    }
  end
end
