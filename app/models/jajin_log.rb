# == Schema Information
#
# Table name: jajin_logs
#
#  id             :integer          not null, primary key
#  amount         :float
#  jajinable_id   :integer
#  jajinable_type :string(255)
#  customer_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  merchant_id    :integer
#

class JajinLog < ActiveRecord::Base
  belongs_to :jajinable, polymorphic: true
  belongs_to :customer
  belongs_to :merchant

  default_scope { order('id DESC') }

  def as_json(options=nil)
    company = jajinable.company if jajinable.respond_to?(:company)
    {
      id: id,
      amount: amount,
      log_time: updated_at,
      customer_id: customer_id,
      type: jajinable_type,
      company: company,
      detail: jajinable.as_json
    }
  end

end
