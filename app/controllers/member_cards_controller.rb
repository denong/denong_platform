class MemberCardsController < ApplicationController

  acts_as_token_authentication_handler_for User

  def show
    @member_card = current_customer.try(:member_cards).find_by_merchant_id(params[:merchant_id])
  end
end