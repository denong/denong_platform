class YlTradesController < ApplicationController
  before_action :set_yl_trade, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json
  acts_as_token_authentication_handler_for User

  def index
    @yl_trades = current_customer.try(:yl_trades).paginate(page: params[:page], per_page: 10)
    respond_with(@yl_trades)
  end

  def show
    @yl_trade = current_customer.try(:yl_trades).find_by_card(yl_trade_params[:card])
    respond_with(@yl_trade)
  end

  def new
    @yl_trade = YlTrade.new
    respond_with(@yl_trade)
  end

  def edit
  end

  def create
    @yl_trade = YlTrade.new(yl_trade_params)
    @yl_trade.save
    respond_with(@yl_trade)
  end

  def update
    @yl_trade.update(yl_trade_params)
    respond_with(@yl_trade)
  end

  def destroy
    @yl_trade.destroy
    respond_with(@yl_trade)
  end

  private
    def set_yl_trade
      @yl_trade = YlTrade.find(params[:id])
    end

    def yl_trade_params
      params.require(:yl_trade).permit(
        :trade_time, :log_time, :trade_currency, :trade_state, 
        :gain, :expend, :merchant_ind, :pos_ind, :merchant_name, 
        :merchant_type, :merchant_city, :trade_type, :trade_way, 
        :merchant_addr, :card)
    end

end

