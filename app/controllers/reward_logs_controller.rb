class RewardLogsController < ApplicationController
  before_action :set_reward_log, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @reward_logs = RewardLog.all
    respond_with(@reward_logs)
  end

  def show
    respond_with(@reward_log)
  end

  def new
    @reward_log = RewardLog.new
    respond_with(@reward_log)
  end

  def edit
  end

  def create
    @reward_log = RewardLog.new(reward_log_params)
    @reward_log.save
    respond_with(@reward_log)
  end

  def update
    @reward_log.update(reward_log_params)
    respond_with(@reward_log)
  end

  def destroy
    @reward_log.destroy
    respond_with(@reward_log)
  end

  private
    def set_reward_log
      @reward_log = RewardLog.find(params[:id])
    end

    def reward_log_params
      params.require(:reward_log).permit(:reward_id, :customer_id, :merchant_id, :amount, :float, :verify_code, :verify_time)
    end
end
