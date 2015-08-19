class MemberCardsController < ApplicationController

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index, :show, :bind, :unbind], fallback_to_devise: false
  acts_as_token_authentication_handler_for Agent, only: [:bind, :check_member_card], fallback_to_devise: false
  def index
    @member_cards = current_customer.try(:member_cards).paginate(page: params[:page], per_page: 10)
  end

  def show
    if params[:merchant_id].present?
      @member_card = current_customer.try(:member_cards).find_by(merchant_id: params[:merchant_id])
    else
      @member_card = current_customer.try(:member_cards).find_by(id: params[:id])
    end
    
  end

  def bind
    if current_agent.present? && bind_params[:phone].present?
      user = User.find_by_phone(bind_params[:phone])
      if user.present? && user.try(:customer).present?
        bind_params[:customer_id] = user.customer.id
        @member_card = MemberCard.find_or_create_by(customer_id: user.customer.id, merchant_id: bind_params[:merchant_id], user_name: bind_params[:user_name], passwd: bind_params[:passwd], point: 0)
      else
        # 错误码： customer不存在
        @error_code = "7201001"
      end
    elsif current_customer.present?
      @member_card = current_customer.member_cards.build bind_params
      logger.info "#{@member_card.errors}"
    end
    @member_card.save
    respond_with @member_card
  end

  def unbind
    @member_card = current_customer.try(:member_cards).find params[:id]
    @unbind_result = false
    if @member_card.present?
      @member_card.destroy
      @unbind_result = true
    end
  end

  def check_member_card
    merchant = current_agent.try(:merchants).find_by_id(check_params[:merchant_id])
    user = User.find_by_phone(check_params[:phone])

    if merchant.present? && user.present? && user.try(:customer).present?
      @member_card = merchant.try(:member_cards).find_by_customer_id(user.try(:customer).try(:id))
    end
  end

  private

    def bind_params
      params.require(:member_card).permit(:merchant_id, :user_name, :passwd, :phone)
    end

    def check_params
      params.require(:member_card).permit(:merchant_id, :phone)
    end
end