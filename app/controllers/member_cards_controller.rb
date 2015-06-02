class MemberCardsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User

  def index
    @member_cards = current_customer.try(:member_cards).paginate(page: params[:page], per_page: 10)
  end

  def show
    @member_card = current_customer.try(:member_cards).find_by_merchant_id(params[:merchant_id])
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

  private

    def bind_params
      params.require(:member_card).permit(:merchant_id, :user_name, :passwd)
    end

end