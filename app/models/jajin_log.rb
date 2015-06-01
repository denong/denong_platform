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
  include ActionView::Helpers::AssetUrlHelper
  
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
      merchant_logo: merchant_logo_url,
      merchant_name: merchant_name,
      detail: jajinable.as_json
    }
  end

  def merchant_logo_url
    merchant.try(:sys_reg_info).try(:image) ? image_url(merchant.sys_reg_info.image.photo.url(:product)) : ""
  end

  def merchant_name
    merchant.try(:sys_reg_info).try(:sys_name)
  end

end
