class ExchangeLogsController < ApplicationController

  respond_to :json

  acts_as_token_authentication_handler_for User

  def create
    @exchange_log = current_customer.exchange_logs.build exchange_log_params
    @exchange_log.save
    respond_with(@exchange_log)
  end

  private

    def exchange_log_params
      params.require(:exchange_log).permit(:amount)
    end
end
