class RelateRewardsController < ApplicationController
  # before_action :set_relate_reward, only: [:show]
  # acts_as_token_authentication_handler_for User, only: [:create]
  respond_to :json

  def create
    @relate_reward = RelateReward.new(relate_reward_params)
    status = Reward.verify?(@relate_reward.verify_code)
    @resp_info = ResponseInfo.new
    if status
      if @relate_reward.save!
        @resp_info.code = 1
        @resp_info.msg ="记录创建成功."
      else
        @resp_info.code = 7204001
        @resp_info.msg = "记录创建失败!"
      end
    else
      @resp_info.code = 7203001
      @resp_info.msg = "奖励码不存在!"
    end
    respond_with(@resp_info)
  end

  private
    def set_relate_reward
      @relate_reward = RelateReward.find(params[:id])
    end

    def relate_reward_params
      params.require(:relate_reward).permit(:verify_code, :phone)
    end
end
