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

  scope :in, -> { where "amount > 0" }
  scope :out, -> { where "amount < 0" }

  after_create :send_notification

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
    merchant.try(:sys_reg_info).try(:logo) ? merchant.sys_reg_info.logo.photo.url(:product) : ""
  end

  def merchant_name
    merchant.try(:sys_reg_info).try(:sys_name)
  end

  private

    def send_notification
      title = "德浓小确幸"
      company = jajinable.company if jajinable.respond_to?(:company)
      price = jajinable.respond_to?(:price) ? jajinable.price : 0
      params = {}

      message = ConsumeMessage.new
      message.title = "返金提醒"
      message.trade_time = updated_at
      message.amount = amount
      message.company = company
      message.customer_id = customer_id
      message.merchant_id = merchant_id
      message.price = price
      message.save
      message.reload

      send_wechat_notification message
      send_xg_notification message
    end

    def send_wechat_notification message
      user = customer.try(:user)
      if user.present?
        url = "http://bjj.dingzhiweixin.com/mobilebjj/pushcri"
        params = {
          phone: user.phone,
          merchant_name: merchant.try(:sys_name),
          amount: message.amount,
          company: message.company,
          price: message.price
          trade_time: message.trade_time
        }
        conn = Faraday.new(url: url)
        response = conn.post url, params
        logger.info "sended wechat notification, response is: #{response.inspect}"
      end
    end

    def send_xg_notification message
      user = customer.try(:user)
      if user.present? && user.os.present? && user.device_token.present?
        content = "您有小金入账，快快查收！实名认证后就能转养老金哦～"
        params = {}
        custom_content = {
          custom_content: {
            id: message.id,
            title: message.title,
            trade_time: updated_at,
            merchant_name: merchant.try(:sys_name),
            amount: message.amount,
            company: message.company,
            customer_id: message.customer_id,
            price: message.price
            merchant_logo: merchant.try(:sys_reg_info).try(:logo) ? merchant.sys_reg_info.logo.photo.url(:product) : "",
            merchant_id: merchant_id
          }
        }
        sender = nil
        if user.os.to_s.downcase.to_sym == :android
          custom_content.merge!({
              action: {
                action_type: 1,
                activity: "net.izhuo.app.happilitt.MessageDetailActivity"
              }
            })
          sender = Xinge::Notification.instance.android
        elsif user.os.to_s.downcase.to_sym == :ios
          sender = Xinge::Notification.instance.ios
          custom_content = {
            id: message.id
          }
        end
        response = sender.pushToSingleDevice user.device_token, message.title, content, params, custom_content
        logger.info "sended xg notification #{id}, response is: #{response.inspect}"
      end
    end

end
