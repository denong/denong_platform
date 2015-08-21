class StatusCodesController < ApplicationController
  before_action :set_status_code, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @status_codes = StatusCode.all
    respond_with(@status_codes)
  end

  def show
    respond_with(@status_code)
  end

  def new
    @status_code = StatusCode.new
    respond_with(@status_code)
  end

  def edit
  end

  def create
    @status_code = StatusCode.new(status_code_params)
    @status_code.save
    respond_with(@status_code)
  end

  def update
    @status_code.update(status_code_params)
    respond_with(@status_code)
  end

  def destroy
    @status_code.destroy
    respond_with(@status_code)
  end

  private
    def set_status_code
      @status_code = StatusCode.find(params[:id])
    end

    def status_code_params
      params[:status_code]
    end
end
