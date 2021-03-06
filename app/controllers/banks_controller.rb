class BanksController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    @banks = BankSearch.search params
  end

end
