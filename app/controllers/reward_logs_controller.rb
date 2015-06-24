class RewardLogsController < ApplicationController

  before_action :set_reward_log, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  acts_as_token_authentication_handler_for User, only: [:verify]

  def index
    @reward_logs = RewardLog.all
    respond_with(@reward_logs)
  end

  def show
    respond_with(@reward_log)
  end

  def new
    @reward_log = RewardLog.new
    @reward_log.verify_code = params[:verify_code]
    respond_with(@reward_log)
  end

  def edit
  end

  def create
    user = User.find_or_create_by_phone(reward_log_params[:phone])
    @reward_log = RewardLog.new(reward_log_params)
    if user.errors.present?
      @reward_log.errors.add :phone, "您输入的手机号有误，请重新输入"
      respond_with(@reward_log)
    else
      @reward_log.customer = user.customer
      @reward_log.save
      if @reward_log.errors.present?
        respond_with(@reward_log)
      else
        respond_with(@reward_log.jajin_log)
      end
    end
  end

  def verify
    @reward_log = current_customer.reward_logs.build(reward_log_params)
    @reward_log.customer = current_customer
    @reward_log.save
    if @reward_log.errors.present?
      respond_with(@reward_log)
    else
      respond_with(@reward_log.jajin_log)
    end
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
      params.require(:reward_log).permit(:verify_code, :phone)
    end
end
