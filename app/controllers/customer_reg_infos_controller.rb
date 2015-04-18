class CustomerRegInfosController < ApplicationController
  before_action :set_customer_reg_info, only: [:show, :update]

  acts_as_token_authentication_handler_for User
  respond_to :html, :json

  def show
    respond_with(@customer_reg_info)
  end

  def update
    @customer_reg_info.update(update_params)
    respond_with(@customer_reg_info)
  end

  private
    def set_customer_reg_info
      @customer_reg_info = CustomerRegInfo.find(params[:id])
    end

    def update_params
      params.require(:customer_reg_info).permit(:nick_name, :gender,
        image_attributes: [:id, :photo, :_destroy])
    end
end
