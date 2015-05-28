require 'will_paginate/array'
class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :add_tag, :update, :follow, :unfollow, :member_cards]

  respond_to :json
  acts_as_token_authentication_handler_for MerchantUser, only: [:update]
  acts_as_token_authentication_handler_for User, only: [:index, :customer_index, :follow, :unfollow, :member_cards]

  def index
    # @merchants = Merchant.all.paginate(page: params[:page], per_page: 10)
    @merchants = MerchantSearch.search params
  end

  def show
    respond_with(@merchant)
  end
  
  def customer_index
    @merchants = current_customer.get_up_voted(Merchant).paginate(page: params[:page], per_page: 10)
  end

  def add_tag
    @merchant.add_tag tag_params if @merchant.present?
  end

  def update
    @merchant = current_merchant
    @merchant.sys_reg_info.update(update_params)
    respond_with(@merchant)
  end

  def get_followers
    @voters = current_merchant.get_likes.by_type(Customer).voters
  end

  def follow
    if @merchant.present?
      current_customer.follow! @merchant
    end
  end

  def unfollow
    if @merchant.present?
      current_customer.unfollow! @merchant
    end
  end

  def member_cards
    if @merchant.present?
      current_customer.add_member_card member_cards_params, @merchant.id
    end
  end

  private

    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    def tag_params
      params.require(:merchant).permit(:tags)
    end

    def update_params
      params.require(:merchant).permit(:sys_name, :contact_person, :service_tel, :fax_tel, :email, :company_addr, :region, :postcode, :lon, :lat, :welcome_string, :comment_text, 
        image_attributes: [:id, :photo, :_destroy])      
    end

    def member_cards_params
      params.require(:merchant).permit(:user_name, :passwd)
    end

end

