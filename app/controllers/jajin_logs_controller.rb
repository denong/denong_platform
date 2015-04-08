class JajinLogsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User

  def index
    @jajin_logs = JajinLog.all.paginate(page: params[:page], per_page: 10)
  end

  def show
    @jajin_log = JajinLog.find params[:id]
  end
end
