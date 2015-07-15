class MemberCardPointLogController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User

  def create
    @member_card_point_log = current_customer.member_card_point_logs.build create_params
    @member_card_point_log.save
    respond_with @member_card_point_log
  end

  def index
    if params[:member_card_id].present?
      @member_card_point_logs = current_customer.try(:member_cards).find_by(id: params[:member_card_id]).try(:member_card_point_logs).paginate(page: params[:page], per_page: 10)
    else
      @member_card_point_logs = current_customer.try(:member_card_point_logs).paginate(page: params[:page], per_page: 10)
    end
    
  end

  def show
    @member_card_point_log = current_customer.try(:member_card_point_logs).find_by(id: params[:id])
  end

  private
    def create_params
      params.require(:member_card_point_log).permit(:member_card_id, :point)
    end

end
