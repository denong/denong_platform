module Admin
  class AgentsController < Admin::ApplicationController
    before_action :set_current_agent
    layout 'admin/home'

    def index
    end
    
    def upload
      @agent = Agent.where(id: params[:id]).first

      render :template => "/admin/agents/import"
    end

    def import
      if params[:import_file].nil? or params[:import_file][:file].nil?
        return redirect_to upload_admin_agent_path(@agent), notice: "文件不能为空!!!"
      end
      file = params[:import_file][:file].read
      file_name = params[:import_file][:file].original_filename
      file_folder = File.join(Rails.root, 'tmp', 'upload_file')
      FileUtils.makedirs(file_folder) unless File.exist?(file_folder)
      target_file = File.open(File.join(file_folder, file_name), 'wb')
      target_file.write file
      target_file.close
      MemberCardPointLog.new.import(target_file)

      redirect_to upload_admin_agent_path(@agent), notice: "文件导入成功!正在处理数据..."
    end

    private
    def set_current_agent
      @agent = current_admin_agent
    end
  end
end
