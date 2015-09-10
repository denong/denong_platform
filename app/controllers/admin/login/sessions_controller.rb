module Admin
  class Login::SessionsController < Devise::SessionsController
    # acts_as_token_authentication_handler_for Agent, only: [:create]
    before_filter :configure_sign_in_params, only: [:create]
    skip_before_filter :verify_authenticity_token
    layout 'admin/devise'
    # GET /resource/sign_in
    def new
      super
    end

    # POST /resource/sign_in
    def create
      super
    end

    # DELETE /resource/sign_out
    def destroy
      p "------------------------------------destroy-----------------------------------------"
      p "agent: #{current_admin_agent}"
      super
    end

    protected

    # You can put the params you want to permit in the empty array.
    def configure_sign_in_params
      devise_parameter_sanitizer.for(:sign_in) << :attribute
    end
  end
end
