class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :destroy, :add_merchant, :add_tag]

  respond_to :html, :json

  def index
    @topics = Topic.all.paginate(page: params[:page], per_page: 10)
    respond_with(@topics)
  end

  def show
    respond_with(@topic)
  end

  def new
    @topic = Topic.new
    respond_with(@topic)
  end

  def edit
  end

  def create
    init_params = create_params
    init_params[:tags] = create_params[:tags].split(",")
    @topic = Topic.new(init_params)
    @topic.save
    respond_with(@topic)
  end

  def destroy
    @topic.destroy
    respond_with(@topic)
  end

  def add_merchant
    if @topic.present?
      @topic.add_merchant merchant_params
    end
    # @topic.merchants = @topic.merchants.paginate(page: params[:topic][:page], per_page: 10)
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def create_params
      params.require(:topic).permit(:title, :subtitle, :tags, pic_attributes: [:id, :photo, :_destroy])
    end

    def merchant_params
      params.require(:topic).permit(:merchant_id)
    end

end
