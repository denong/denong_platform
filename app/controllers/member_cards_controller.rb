class MemberCardsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User
  before_action :set_member_card, only: [:bind]

  def show
    @member_card = current_customer.try(:member_cards).find_by_merchant_id(params[:merchant_id])
  end

  def bind
    if @member_card.present? && @merchant.present?
      current_customer.bind_member_card! @member_card
      @merchant.bind_member_card! @member_card
    end
  end

  private

    def set_member_card
      @member_card = MemberCard.find( params[:id] )
      @merchant = Merchant.find ( params[:merchant_id])
    end

end