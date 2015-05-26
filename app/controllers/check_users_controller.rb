class CheckUsersController < ApplicationController
  def show
    phone = params[:phone]
    @check_user = User.exists? phone: phone
  end

  def reset
    @user = User.reset_user_password params 
  end
end
