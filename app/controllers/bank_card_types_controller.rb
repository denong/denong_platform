class BankCardTypesController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    @bank_card_types = BankCardTypeSearch.search params
  end

end