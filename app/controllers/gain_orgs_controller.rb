class GainOrgsController < ApplicationController
  before_action :set_gain_org, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @gain_orgs = GainOrg.all
    respond_with(@gain_orgs)
  end

  def show
    respond_with(@gain_org)
  end

  def new
    @gain_org = GainOrg.new
    respond_with(@gain_org)
  end

  def edit
  end

  def create
    @gain_org = GainOrg.new(gain_org_params)
    @gain_org.save
    respond_with(@gain_org)
  end

  def update
    @gain_org.update(gain_org_params)
    respond_with(@gain_org)
  end

  def destroy
    @gain_org.destroy
    respond_with(@gain_org)
  end

  private
    def set_gain_org
      @gain_org = GainOrg.find(params[:id])
    end

    def gain_org_params
      params[:gain_org]
    end
end
