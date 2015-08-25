class IdentityVerifiesController < ApplicationController
  before_action :set_identity_verify, only: [:update]

  acts_as_token_authentication_handler_for User, only: [:index, :create], fallback_to_devise: false
  acts_as_token_authentication_handler_for MerchantUser, only: [:update], fallback_to_devise: false
  acts_as_token_authentication_handler_for Agent, only: [:create], fallback_to_devise: false
  respond_to :html, :json

  def create
    if current_customer.present?
      @identity_verify = current_customer.identity_verifies.build(create_params)
      @identity_verify.save
      respond_with(@identity_verify)
    elsif current_agent.present?
      params = create_params
      user = User.find_by_phone(params[:phone])
      if user.present? && user.try(:customer).present?
        params.delete(:phone)
        params[:name].encode! 'utf-8', 'gbk', {:invalid => :replace} if params[:name].encoding.name != "UTF-8"
        @identity_verify = user.try(:customer).identity_verifies.build(params)
        @identity_verify.save
        respond_with(@identity_verify)
      else
        @error_code = "7201001"
      end
    end
  end

  def update
    @identity_verify.update(update_params)
    respond_with(@identity_verify)
  end


  def index
    @identity_verify = current_customer.identity_verifies.try(:last)
  end

  private
    def set_identity_verify
      @identity_verify = IdentityVerify.find(params[:id])
    end

    def create_params
      params.require(:identity_verify).permit(:phone, :name, :id_card,
          front_image_attributes: [:id, :photo, :_destroy],
          back_image_attributes: [:id, :photo, :_destroy]
          )
    end

    def update_params
      params.require(:identity_verify).permit(:verify_state)
    end
end
