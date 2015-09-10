module Admin
  class LoginController < Devise::SessionsController

    def new
      super
      
    end
  end
end
