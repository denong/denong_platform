class CustomerRegInfosController < ApplicationController
  before_action :set_customer_reg_info, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @customer_reg_infos = CustomerRegInfo.all
    respond_with(@customer_reg_infos)
  end

  def show
    respond_with(@customer_reg_info)
  end

  def new
    @customer_reg_info = CustomerRegInfo.new
    respond_with(@customer_reg_info)
  end

  def edit
  end

  def create
    @customer_reg_info = CustomerRegInfo.new(customer_reg_info_params)
    @customer_reg_info.save
    respond_with(@customer_reg_info)
  end

  def update
    @customer_reg_info.update(customer_reg_info_params)
    respond_with(@customer_reg_info)
  end

  def destroy
    @customer_reg_info.destroy
    respond_with(@customer_reg_info)
  end

  private
    def set_customer_reg_info
      @customer_reg_info = CustomerRegInfo.find(params[:id])
    end

    def customer_reg_info_params
      params[:customer_reg_info]
    end
end
