class MerchantCustomersController < ApplicationController
  respond_to :json
  before_action :verify_params, only: [:verify]
  acts_as_token_authentication_handler_for User
  
  def verify
    unless verify_params[:name].present?
      render json: { status: 'error', message: "手机/姓名/ID不能为空!" } 
      return
    end
    @merchant = Merchant.find_by(params[:id])
    if @merchant.present?
      @m_customer = @merchant.merchant_customers.where("name like ? or u_id like ? or phone like ?", "%#{verify_params[:name]}%", "%#{verify_params[:name]}%", "%#{verify_params[:name]}%")
      if @m_customer.first.present?
        if verify_params[:password].eql?(@m_customer.first.password)
          render json: { status: "ok", message: "绑定成功.", customer_point: @m_customer.first.jifen }
        else
          render json: { status: "error", message: "对不起,您输入的密码有误,请确认后重试!" }
        end
      else
        render json: { status: "error", message: "对不起,您输入的帐号不存在,请确认!" }
      end
    else
      render json: { status: 'error', message: "您选择的商户不存在!" }
    end
  end

  private
  def verify_params
    params.require(:merchant_customer).permit(:name, :password)
  end
end
