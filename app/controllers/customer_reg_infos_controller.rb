class CustomerRegInfosController < ApplicationController

  acts_as_token_authentication_handler_for User, only: [:show, :update]
  acts_as_token_authentication_handler_for Agent, only: [:verify_state]
  respond_to :html, :json

  def show
    if params[:id]
      @customer_reg_info = Customer.find(params[:id]).customer_reg_info
    else
      @customer_reg_info = current_customer.customer_reg_info
    end
    # respond_with(@customer_reg_info)
  end

  def update
    @customer_reg_info = current_customer.customer_reg_info
    @customer_reg_info.update(update_params)
    respond_with(@customer_reg_info)
  end

  def verify_state
    @customer_reg_info = CustomerRegInfo.get_reg_info_by_phone query_params[:phone]
    respond_with(@customer_reg_info)
  end

  private

    def update_params
      params.require(:customer_reg_info).permit(:nick_name, :gender,
        image_attributes: [:id, :photo, :_destroy])
    end

    def query_params
      params.require(:customer_reg_info).permit(:phone)      
    end
end
