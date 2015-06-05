class ConsumeMessagesController < ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :set_consume_message, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json


  def index
    @consume_messages = ConsumeMessage.all
    respond_with(@consume_messages)
  end

  def show
    respond_with(@consume_message)
  end

  def new
    @consume_message = ConsumeMessage.new
    respond_with(@consume_message)
  end

  def edit
  end

  def create
    @consume_message = ConsumeMessage.new(consume_message_params)
    @consume_message.save
    respond_with(@consume_message)
  end

  def update
    @consume_message.update(consume_message_params)
    respond_with(@consume_message)
  end

  def destroy
    @consume_message.destroy
    respond_with(@consume_message)
  end

  private
    def set_consume_message
      @consume_message = current_customer.consume_messages.find(params[:id])
    end

    def consume_message_params
      params[:consume_message]
    end
end
