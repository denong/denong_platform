class PensionLogsController < ApplicationController
  before_action :set_pension_log, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    if params[:search] == "in"
      @pension_logs = current_customer.pension_logs.in.paginate(page: params[:page], per_page: 10)
    elsif params[:search] == "out"
      @pension_logs = current_customer.pension_logs.out.paginate(page: params[:page], per_page: 10)
    else
      @pension_logs = current_customer.pension_logs.paginate(page: params[:page], per_page: 10)
    end
    respond_with(@pension_logs)
  end

  def show
    respond_with(@pension_log)
  end

  def new
    @pension_log = PensionLog.new
    respond_with(@pension_log)
  end

  def edit
  end

  def create
    @pension_log = PensionLog.new(pension_log_params)
    @pension_log.save
    respond_with(@pension_log)
  end

  def update
    @pension_log.update(pension_log_params)
    respond_with(@pension_log)
  end

  def destroy
    @pension_log.destroy
    respond_with(@pension_log)
  end

  private
    def set_pension_log
      @pension_log = PensionLog.find(params[:id])
    end

    def pension_log_params
      params[:pension_log]
    end
end
