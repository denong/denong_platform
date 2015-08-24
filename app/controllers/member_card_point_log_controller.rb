class MemberCardPointLogController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:create, :index, :show], fallback_to_devise: false
  acts_as_token_authentication_handler_for Agent, only: [:create, :index], fallback_to_devise: false
  acts_as_token_authentication_handler_for MerchantUser, only: [:index], fallback_to_devise: false

  def create
    if current_agent.present?
      member_card = MemberCard.find_by_id(create_params[:member_card_id])
      if MemberCardPointLog.find_by_unique_ind(create_params[:unique_ind]).present?
        return
      end
      if member_card.present? && create_params[:unique_ind].present? && !(MemberCardPointLog.find_by_unique_ind(create_params[:unique_ind]).present?)
        params = create_params
        params[:point] = params[:point].to_i
        params[:point] *= -1 if params[:point].to_i > 0 
        params[:customer_id] = member_card.try(:customer).id
        first_time = params.delete(:first_time) || false
        @member_card_point_log = member_card.member_card_point_logs.create(params)
        @member_card_point_log.save
        MemberCardPointLog.send_sms_notification params, first_time unless @member_card_point_log.errors.present?
      end
    elsif current_customer.present?
      @member_card_point_log = current_customer.member_card_point_logs.build create_params
      @member_card_point_log.save
    end
  end

  def index
    if current_agent.present?
      @member_card_point_logs = MemberCardPointLog.get_point_log_by_agent(current_agent.id, index_params)
    elsif current_customer.present?
      if params[:member_card_id].present?
        @member_card_point_logs = current_customer.try(:member_cards).find_by(id: params[:member_card_id]).try(:member_card_point_logs)
      else
        @member_card_point_logs = current_customer.try(:member_card_point_logs)
      end
    elsif current_merchant.present?
      @member_card_point_logs = MemberCardPointLog.get_point_log_by_merchant(current_merchant.id, index_params)
    end

    unless @member_card_point_logs.nil?
      @size = @member_card_point_logs.size
      @member_card_point_logs = @member_card_point_logs.paginate(page: params[:page], per_page: 10)
    end
  end

  def show
    @member_card_point_log = current_customer.try(:member_card_point_logs).find_by(id: params[:id])
  end

  private
    def create_params
      params.require(:member_card_point_log).permit(:member_card_id, :point, :unique_ind, :first_time)
    end

    def index_params
      params.require(:member_card_point_log).permit(:phone, :begin_time, :end_time)
    end

end
