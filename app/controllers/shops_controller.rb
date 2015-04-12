require 'will_paginate/array'
class ShopsController < ApplicationController
  
  respond_to :html, :json
  acts_as_token_authentication_handler_for User
  acts_as_token_authentication_handler_for MerchantUser, only: [:new, :create]
  before_action :set_shop, only: [:show, :follow, :unfollow]

  def index
    if params[:merchant_id].present?
      shops = Merchant.find(params[:merchant_id]).shops
    else
      shops = Shop.all
    end
    @shops = shops.paginate(page: params[:page], per_page: 10)
  end

  def new
    @shop = current_merchant.shops.build
  end

  def show
  end

  def follow
    if @shop.present?
      current_customer.follow! @shop
      current_customer.follow! @shop.merchant
    end
  end

  def unfollow
    if @shop.present?
      current_customer.unfollow! @shop
      current_customer.unfollow! @shop.merchant
    end
  end

  def neighbour_shop 
    @shops = (Shop.get_neighbour_shop addr_data_params).paginate(page: params[:page], per_page: 10)
  end

  private

    def set_shop
      @shop = Shop.find(params[:id])
    end

    def addr_data_params
      params.require(:shop).permit(:lon, :lat)
    end 

end
