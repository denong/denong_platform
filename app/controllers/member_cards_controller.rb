class MemberCardsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index, :show, :bind, :unbind]
  acts_as_token_authentication_handler_for Agent, only: [:check_member_card]
  def index
    @member_cards = current_customer.try(:member_cards).paginate(page: params[:page], per_page: 10)
  end

  def show
    if params[:merchant_id].present?
      @member_card = current_customer.try(:member_cards).find_by(merchant_id: params[:merchant_id])
    else
      @member_card = current_customer.try(:member_cards).find_by(id: params[:id])
    end
    
  end

  def bind
    @member_card = current_customer.member_cards.build bind_params
    @member_card.save
    respond_with @member_card
  end

  def unbind
    @member_card = current_customer.try(:member_cards).find params[:id]
    @unbind_result = false
    if @member_card.present?
      @member_card.destroy
      @unbind_result = true
    end
  end

  def check_member_card
    merchant = current_agent.try(:merchants).find_by_id(check_params[:merchant_id])
    user = User.find_by_phone(check_params[:phone])

    if merchant.present? && user.present? && user.try(:customer).present?
      @member_card = merchant.try(:member_cards).find_by_customer_id(user.try(:customer).try(:id))
    end
  end

  private

    def bind_params
      params.require(:member_card).permit(:merchant_id, :user_name, :passwd)
    end

    def check_params
      params.require(:member_card).permit(:merchant_id, :phone)
    end
end