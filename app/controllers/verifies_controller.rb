class VerifiesController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User

  def show
    init_params = {}
    init_params[:verify_code] = verify_params[:ckh]
    init_params[:amount] = verify_params[:amt]

    @jajin_verify_log = current_customer.jajin_verify_logs.create init_params
  end

  private

    def verify_params
      params.require(:verify).permit(:ckh, :date, :time, :amt)
    end

end