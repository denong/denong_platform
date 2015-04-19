class GivenLogsController < ApplicationController
  
  respond_to :json
  acts_as_token_authentication_handler_for User

  def create
    given_customer = Customer.find_by_id(given_log_params[:giver_or_given_id])

    @giver_log, given_log = GivenLog.add_both_given_log current_customer, given_customer, given_log_params[:amount]
    @giver_log.save
    respond_with(@giver_log)
  end

  private

    def given_log_params
      params.require(:given_log).permit(:amount, :giver_or_given_id)
    end
end
