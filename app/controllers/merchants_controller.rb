require 'will_paginate/array'
class MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :add_tag, :update, :follow, :unfollow, :like, :unlike, :member_cards, :get_followers]

  respond_to :json
  acts_as_token_authentication_handler_for User, only: [:index, :show], fallback_to_devise: false
  acts_as_token_authentication_handler_for User, only: [:customer_index, :follow, :unfollow, :like, :unlike, :member_cards]

  acts_as_token_authentication_handler_for MerchantUser, only: [:index, :show], fallback_to_devise: false

  acts_as_token_authentication_handler_for Agent, only: [:create, :update], fallback_to_devise: false
  acts_as_token_authentication_handler_for MerchantUser, only: [:update], fallback_to_devise: false

  def create
    if current_agent.present?
      agent = current_agent
    else
      agent = Agent.find_by_id(create_params[:agent_id].to_i)
    end

    unless agent.present?
      return
    end
    @merchant = agent.merchants.build(create_params)
    @merchant.save
    @merchant.sys_reg_info.update(update_params)
    respond_with(@merchant)
  end

  def index
    @merchants = MerchantSearch.search params
  end

  def show
    respond_with(@merchant)
  end
  
  def customer_index
    @merchants = current_customer.votes(vote_scope: "follow").up.for_type(Merchant).votables.paginate(page: params[:page], per_page: 10)
  end

  def add_tag
    @merchant.add_tag tag_params if @merchant.present?
  end

  def update
    @merchant = current_merchant || current_agent.try(:merchants).try(:find, params[:id])
    @merchant.update(create_params)
    @merchant.sys_reg_info.update(update_params)
    respond_with(@merchant)
  end

  def get_followers
    @voters = @merchant.get_likes(vote_scope: "follow").by_type(Customer).voters.paginate(page: params[:page], per_page: 10)
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

  def like
    if @merchant.present?
      current_customer.like! @merchant
    end
  end

  def unlike
    if @merchant.present?
      current_customer.unlike! @merchant
    end
  end

  def member_cards
    if @merchant.present?
      current_customer.add_member_card member_cards_params, @merchant.id
    end
  end

  def verify_merchant
    @verify_result = Merchant.verify_merchant_by_name create_params[:merchant_name]
  end

  private

    def set_merchant
      @merchant = Merchant.find(params[:id])
    end

    def tag_params
      params.require(:merchant).permit(:tags)
    end

    def update_params
      params.require(:merchant).permit(:sys_name,
        :contact_person, :service_tel, :fax_tel, :email, 
        :company_addr, :region, :postcode, :lon, :lat, 
        :welcome_string, :comment_text, :contact_tel, 
        image_attributes: [:id, :photo, :_destroy],
        logo_attributes: [:id, :photo, :_destroy])      
    end

    def member_cards_params
      params.require(:merchant).permit(:user_name, :passwd)
    end

    def create_params
      params.require(:merchant).permit(:ratio, :merchant_user_id, :agent_id)
    end

    def verify_params
      params.require(:merchant).permit(:merchant_name)
    end
end

