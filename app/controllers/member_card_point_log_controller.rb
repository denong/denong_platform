class MemberCardPointLogController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:create, :index, :show], fallback_to_devise: false
  acts_as_token_authentication_handler_for Agent, only: [:create, :index], fallback_to_devise: false
  acts_as_token_authentication_handler_for MerchantUser, only: [:index], fallback_to_devise: false

  def create
    @member_card_point_log = current_customer.member_card_point_logs.build create_params
    @member_card_point_log.save
    respond_with @member_card_point_log
  end

  def index
    if current_agent.present?
      @member_card_point_logs = MemberCardPointLog.get_point_log_by_agent(current_agent.id, index_params)
      unless @member_card_point_logs.nil?
        @member_card_point_logs = @member_card_point_logs.paginate(page: params[:page], per_page: 10)
      end
    elsif current_customer.present?
      if params[:member_card_id].present?
        @member_card_point_logs = current_customer.try(:member_cards).find_by(id: params[:member_card_id]).try(:member_card_point_logs).paginate(page: params[:page], per_page: 10)
      else
        @member_card_point_logs = current_customer.try(:member_card_point_logs).paginate(page: params[:page], per_page: 10)
      end
    elsif current_merchant.present?
      @member_card_point_logs = MemberCardPointLog.get_point_log_by_merchant(current_merchant.id, index_params)
      unless @member_card_point_logs.nil?
        @member_card_point_logs = @member_card_point_logs.paginate(page: params[:page], per_page: 10)
      end
    end
  end

  def show
    @member_card_point_log = current_customer.try(:member_card_point_logs).find_by(id: params[:id])
  end

  private
    def create_params
      params.require(:member_card_point_log).permit(:member_card_id, :point)
    end

    def index_params
      params.require(:member_card_point_log).permit(:phone, :begin_time, :end_time)
    end

end
