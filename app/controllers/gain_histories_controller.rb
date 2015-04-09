class GainHistoriesController < ApplicationController

  acts_as_token_authentication_handler_for User

  def index
    @gain_histories = current_customer.try(:gain_histories)
  end

  def show
    @gain_history = current_customer.try(:gain_histories).last
  end
end
