class VerifiesController < ApplicationController
  respond_to :json
  acts_as_token_authentication_handler_for User

  def show
    if check_params verify_params
      @jajin_verify_log = JajinVerifyLog.create verify_params
    end
  end

  private

    def check_params verify_params
      jajin_identity_code = JajinIdentityCode.find(verify_code: verify_params[:ckh])
      if jajin_identity_code && 
        jajin_identity_code[:created_at].to_date == verify_params[:date] &&
        jajin_identity_code[:created_at].to_time == verify_params[:time] && 
        jajin_identity_code[:amount] == verify_params[:amt]
        true
      else
        false  
      end
    end

    def verify_params
      params.scope(:verify).permit(:ckh, :date, :time, :amt)
    end

end
