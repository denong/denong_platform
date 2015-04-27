class CheckUsersController < ApplicationController
  def show
    phone = params[:phone]
    @check_user = User.exists? phone: phone
  end
end
