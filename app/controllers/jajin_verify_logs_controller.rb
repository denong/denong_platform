class JajinVerifyLogsController < ApplicationController
  respond_to :html, :json

  # acts_as_token_authentication_handler_for User

  def new
    @verify_log = JajinVerifyLog.new
    @verify_log.verify_code = params[:verify_code]
  end

  def create
    user = User.find_or_create_by_phone jajin_verify_log_params[:phone]
    @verify_log = user.customer.jajin_verify_logs.build jajin_verify_log_params
    # @verify_log = current_customer.jajin_verify_logs.build jajin_verify_log_params
    @verify_log.save
    if @verify_log.errors.present?
      respond_with(@verify_log)
    else
      respond_with(@verify_log.jajin_log)
    end
  end

  private

    def jajin_verify_log_params
      params.require(:jajin_verify_log).permit(:phone, :verify_code)
    end
end
