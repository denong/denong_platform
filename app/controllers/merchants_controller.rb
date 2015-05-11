require 'will_paginate/array'
class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :add_tag]

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index, :show, :customer_index]

  def index
    @merchants = Merchant.all.paginate(page: params[:page], per_page: 10)
  end

  def show
    respond_with(@merchant)
  end
  
  def customer_index
    @merchants = current_customer.get_giving_jajin_merchant.paginate(page: params[:page], per_page: 10)
  end

  def add_tag
    @merchant.add_tag tag_params if @merchant.present?
  end

  private

    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    def tag_params
      params.require(:merchant).permit(:tags)
    end
end
