class BalanceLogsController < ApplicationController

  acts_as_token_authentication_handler_for MerchantUser, only: [:index, :create]
  respond_to :json

  def index
    @jajin_identity_codes = current_merchant.balance_logs.paginate(page: params[:page], per_page: 10)
  end

  def create
    @jajin_identity_code = current_merchant.balance_logs.new(create_params)
    @jajin_identity_code.save
    respond_with(@jajin_identity_code)
  end

  private

    def create_params
      params.require(:balance_logs).permit(:balance)
    end
end
