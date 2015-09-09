module Admin
  class AgentsController < ApplicationController
    before_action :set_current_agent
    layout 'admin/home'

    def index
    end
    
    def upload
      @agent = Agent.where(:id => params[:id]).first
    end

    def import
      p "--------------------start-----------------------"
      MemberCardPointLog.new.import(params[:import_file][:file])
      p "----------------------end---------------------"
      return redirect_to admin_agents_path  
    end

    private
    def set_current_agent
      @agent = current_admin_agent
    end
  end
end
