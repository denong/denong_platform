class IdentityVerifiesController < ApplicationController
  before_action :set_identity_verify, only: [:update]

  acts_as_token_authentication_handler_for User#, only: [:create]
  
  respond_to :html, :json

  def create
    @identity_verify = current_customer.identity_verifies.build(create_params)
    @identity_verify.front_image = params[:identity_verify][:front_image_attributes]
    @identity_verify.save
    respond_with(@identity_verify)
  end

  def update
    @identity_verify.update(update_params)
    respond_with(@identity_verify)
  end


  def index
    @identity_verify = current_customer.identity_verifies.first
  end

  private
    def set_identity_verify
      @identity_verify = IdentityVerify.find(params[:id])
    end

    def create_params
      params.require(:identity_verify).permit(:name, :id_num,
          front_image_attributes: [:id, :photo, :_destroy],
          back_image_attributes: [:id, :photo, :_destroy]
          )
    end

    def update_params
      params.require(:identity_verify).permit(:verify_state)
    end
end
