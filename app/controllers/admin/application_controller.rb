require "application_responder"
module Admin
  class ApplicationController < ActionController::Base
    self.responder = ApplicationResponder
    respond_to :html

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :null_session

    before_action :configure_permitted_parameters, if: :devise_controller?

    def current_customer
      current_user.try(:customer)
    end

    def current_merchant
      current_merchant_user.try(:merchant)
    end

    helper_method :current_customer, :current_merchant, :current_agent

    protected

    def configure_permitted_parameters
      # devise_parameter_sanitizer.for(:sign_up).concat [:sms_token]
      # 此处过滤待完善
      # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:sms_token, :name, :phone, :contact_person, :email, :password, :password_confirmation, :user_source, :source_id) }
    end
  end
end
