class CustomerRegInfosController < ApplicationController

  acts_as_token_authentication_handler_for User, only: [:show, :update]
  acts_as_token_authentication_handler_for Agent, only: [:verify_state]
  # after_filter :cors_set_access_control_headers, :update
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
    @customer_reg_info = CustomerRegInfo.get_reg_info_by_phone query_params
    respond_with(@customer_reg_info)
  end

  private
    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      # headers['Access-Control-Allow-Headers'] = 'X-AUTH-TOKEN, X-API-VERSION, X-Requested-With, Content-Type, Accept, Origin'
      # headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      # headers['Access-Control-Max-Age'] = "1728000"
    end

    def update_params
      params.require(:customer_reg_info).permit(:nick_name, :gender,
        image_attributes: [:id, :photo, :_destroy])
    end

    def query_params
      params.require(:customer_reg_info).permit(:phone, :name, :id_card)      
    end
end
