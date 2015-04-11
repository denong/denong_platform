require 'will_paginate/array'
class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show]

  respond_to :json
  acts_as_token_authentication_handler_for User

  def index
    @merchants = Merchant.all.paginate(page: params[:page], per_page: 10)
  end

  def show
    respond_with(@merchant)
  end
  
  def customer_index
    @merchants = current_customer.get_giving_jajin_merchant.paginate(page: params[:page], per_page: 10)
  end

  private

    def set_merchant
      @merchant = Merchant.find(params[:id])
    end
end
