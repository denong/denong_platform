class JajinVerifyLogsController < ApplicationController
  respond_to :json

  acts_as_token_authentication_handler_for User

  def create
    @verify_log = current_customer.jajin_verify_logs.build jajin_verify_log_params
    @verify_log.save
    if @verify_log.errors.present?
      respond_with(@verify_log)
    else
      respond_with(@verify_log.jajin_log)
    end
  end

  private

    def jajin_verify_log_params
      params.require(:jajin_verify_log).permit(:verify_code)
    end
end
