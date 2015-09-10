module Admin
  class HomeController < Admin::ApplicationController
    before_filter :authenticate_admin_agent!
    
    def index
      @agent = current_admin_agent  
    end
  end

end
