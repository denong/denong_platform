class JajinLogsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    @jajin_logs = current_customer.jajin_logs.paginate(page: params[:page], per_page: 10)
    respond_with(@jajin_logs)
  end

  def show
    # @jajin_log = current_customer.jajin_logs.find params[:id]
    @jajin_log = JajinLog.find params[:id]
  end
end
