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
  # include ActionView::Helpers::AssetUrlHelper

  belongs_to :jajinable, polymorphic: true
  belongs_to :customer
  belongs_to :merchant

  after_create :send_xg_notification

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
      merchant_logo: merchant_logo,
      merchant_name: merchant_name,
      detail: jajinable.as_json
    }
  end

  def merchant_logo
    merchant.try(:sys_reg_info).try(:logo) ? merchant.sys_reg_info.image.photo.url(:product) : ""
  end

  def merchant_name
    merchant.try(:sys_reg_info).try(:sys_name)
  end

  def send_xg_notification
    user = customer.try(:user)
    if user.present? && user.os.present?
      title = "德浓小确幸"
      content = "您有小金入账，快快查收！实名认证后就能转养老金哦～"
      company = jajinable.company if jajinable.respond_to?(:company)
      params = {}
      custom_content = {
        custom_content: {
          id: id,
          trade_time: updated_at,
          merchant_name: merchant.try(:sys_name),
          amount: amount,
          company: company,
          customer_id: customer_id,
          merchant_id: merchant_id
        }
      }
      sender = nil
      if user.os.to_s.downcase.to_sym == :android
        sender = Xinge::Notification.instance.android
      elsif user.os.to_s.downcase.to_sym == :ios
        sender = Xinge::Notification.instance.ios
      end
      response = sender.pushToSingleDevice user.device_token, title, content, params, custom_content
      logger.debug "sended xg notification #{id}, response is: #{response.inspect}"
    end
  end

end
