class CheckUsersController < ApplicationController
  respond_to :json
  
  acts_as_token_authentication_handler_for User, only: [:device]

  def show
    phone = params[:phone]
    @check_user = User.exists? phone: phone
    # 部分用户做特殊处理
    @reset = User.exists? phone: phone, source_id: 28, sign_in_count: 0
  end

  def reset
    @user = User.reset_user_password params 
    respond_with @user
  end

  def device
    @user = User.find current_user.id
    @user.sms_token = "989898"
    @user.os = params[:os]
    @user.device_token = params[:device_token]
    @user.save
  end
end
