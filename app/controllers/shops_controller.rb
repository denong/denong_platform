require 'will_paginate/array'
class ShopsController < ApplicationController
  
  respond_to :html, :json
  acts_as_token_authentication_handler_for User, only: [:follow, :unfollow, :neighbour_shop]
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

  def create
    @shop = current_merchant.shops.build(create_params)
    @shop.save
    respond_with(@shop)
  end

  private

    def set_shop
      @shop = Shop.find(params[:id])
    end

    def addr_data_params
      params.require(:shop).permit(:lon, :lat)
    end 

    def create_params
      params.require(:shop).permit(:name, :addr, :contact_person, 
        :contact_tel, :work_time, :lat, :lon, :post_code, :email, :service_tel,
        :welcome_text, :remark,
        pic_attributes: [:id, :photo, :_destroy], 
        logo_attributes: [:id, :photo, :_destroy])
    end

end


