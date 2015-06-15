class TlTradesController < ApplicationController
  before_action :set_tl_trade, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @tl_trades = TlTrade.all
    respond_with(@tl_trades)
  end

  def show
    respond_with(@tl_trade)
  end

  def new
    @tl_trade = TlTrade.new
    respond_with(@tl_trade)
  end

  def edit
  end

  def create
    @tl_trade = TlTrade.new(tl_trade_params)
    # @tl_trade.merchant_id = 4
    @tl_trade.save
    respond_with(@tl_trade)
  end

  def update
    @tl_trade.update(tl_trade_params)
    respond_with(@tl_trade)
  end

  def destroy
    @tl_trade.destroy
    respond_with(@tl_trade)
  end

  private
    def set_tl_trade
      @tl_trade = TlTrade.find(params[:id])
    end

    def tl_trade_params
      params.require(:tl_trade).permit(:phone, :card, :price, :trade_time, :pos_ind, :shop_ind, :trade_ind, :merchant_id)
    end
end
