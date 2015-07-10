class MemberCardPointLogController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User

  def create
    @member_card_point_log = current_customer.member_card_point_logs.build create_params
    @member_card_point_log.save
    respond_with @member_card_point_log
  end

  private
    def create_params
      params.require(:member_card_point_log).permit(:member_card_id, :point)
    end

end
