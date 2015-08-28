class VerifiesController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User

  def show
    logger.info "#{params}"
    if JajinVerifyLog.tl_varify params
      init_params = {}
      init_params[:verify_code] = params[:ckh]
      init_params[:amount] = params[:amt]
      @jajin_verify_log = current_customer.jajin_verify_logs.find_or_create_by(init_params)
    end

  end

  private

    def verify_params
      params.require(:verify).permit(:ckh, :date, :time, :amt)
    end

end
