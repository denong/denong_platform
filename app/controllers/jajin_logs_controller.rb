class JajinLogsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    if params[:search] == "in"
      @jajin_logs = current_customer.jajin_logs.in.paginate(page: params[:page], per_page: 10)
    elsif params[:search] == "out"
      @jajin_logs = current_customer.jajin_logs.out.paginate(page: params[:page], per_page: 10)
    else
      @jajin_logs = current_customer.jajin_logs.paginate(page: params[:page], per_page: 10)
    end
    respond_with(@jajin_logs)
  end

  def show
    # @jajin_log = current_customer.jajin_logs.find params[:id]
    @jajin_log = JajinLog.find params[:id]
  end
end
