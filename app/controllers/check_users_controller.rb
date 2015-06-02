class CheckUsersController < ApplicationController
  respond_to :json
  
  acts_as_token_authentication_handler_for User, only: [:device]

  def show
    phone = params[:phone]
    @check_user = User.exists? phone: phone
  end

  def reset
    @user = User.reset_user_password params 
    respond_with @user
  end

  def device
    @user = User.find current_user.id
    @user.os = params[:os]
    @user.device_token = params[:device_token]
    @user.save
  end
end
