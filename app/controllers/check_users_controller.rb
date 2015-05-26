class CheckUsersController < ApplicationController
  respond_to :json
  
  def show
    phone = params[:phone]
    @check_user = User.exists? phone: phone
  end

  def reset
    @user = User.reset_user_password params 
    respond_with @user
  end
end
