class LakalaTradesController < ApplicationController
  respond_to :json

  def create
    @error_code, @reason = LakalaTrade.process params
  end

end
