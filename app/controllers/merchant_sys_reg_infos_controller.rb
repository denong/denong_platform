class MerchantSysRegInfosController < ApplicationController
  before_action :set_merchant_sys_reg_info, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @merchant_sys_reg_infos = MerchantSysRegInfo.all
    respond_with(@merchant_sys_reg_infos)
  end

  def show
    respond_with(@merchant_sys_reg_info)
  end

  def new
    @merchant_sys_reg_info = MerchantSysRegInfo.new
    respond_with(@merchant_sys_reg_info)
  end

  def edit
  end

  def create
    @merchant_sys_reg_info = MerchantSysRegInfo.new(merchant_sys_reg_info_params)
    @merchant_sys_reg_info.save
    respond_with(@merchant_sys_reg_info)
  end

  def update
    @merchant_sys_reg_info.update(merchant_sys_reg_info_params)
    respond_with(@merchant_sys_reg_info)
  end

  def destroy
    @merchant_sys_reg_info.destroy
    respond_with(@merchant_sys_reg_info)
  end

  private
    def set_merchant_sys_reg_info
      @merchant_sys_reg_info = MerchantSysRegInfo.find(params[:id])
    end

    def merchant_sys_reg_info_params
      params[:merchant_sys_reg_info]
    end
end
