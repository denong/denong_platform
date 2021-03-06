Rails.application.routes.draw do

  resources :relate_rewards, only: [:create]

  resources :boards

  devise_ios_rails_for :agents
  devise_ios_rails_for :merchant_users  

  resources :sms_tokens, only: [:create]
  resources :pension, only: [:index]
  
  resources :jajin, only: [:index]
  
  resources :merchants, only: [:index, :show, :update, :create] do
    resources :shops, only: [:index, :new, :create, :update]
    collection do
      get 'customer_index'
    end
    member do
      post 'add_tag'
      get 'get_followers'
      post 'follow'
      post 'unfollow'
      post 'like'
      post 'unlike'
      post 'member_cards'
    end
  end

  resource :merchant, only: [:show] 

  match 'merchant/:id/merchant_customer/verify' => 'merchant_customers#verify', :via => [:post]

  resources :shops, only: [:index, :show] do
    member do
      post 'follow'
      post 'unfollow'
    end
    collection do
      post 'neighbour_shop' 
    end
  end

  resources :member_cards, only: [:index, :show] do
    collection do
      post 'check_member_card'
      post 'bind'
    end
    member do
      post 'unbind'
    end
  end
  
  resources :yl_trades, only: [:create, :index, :show]
  resources :merchant_messages, only: [:create, :index] do
    member do
      post 'like'
      post 'unlike'
    end
  end
  resources :merchant_giving_logs, only: [:index, :show]

  resources :bank_cards, only: [:index, :create] do
    collection do
      post 'send_msg'
      get 'bank_info'
      post 'verify'
    end
  end

  resource :merchant_sys_reg_info


  ################################################ 
  # 用户相关的路由
  devise_ios_rails_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # 用户注册资料
  resources :customer_reg_infos, only: [:show] do
    collection do
      get 'verify_state'
    end
  end
  resource :customer_reg_info, only: [:show, :update], :via => :options

  # 用户认证
  resources :identity_verifies, only: [:create, :update, :index]

  # 用户是否存在
  resource :check_user, only: [:show] do
    member do
      post 'reset'
      post 'device'
    end
  end
  ################################################

  ################################################
  # 养老金收益相关路由
  resources :gain_accounts, only: [:index, :show] do
    resources :gain_histories, only: [:index, :show]
  end

  # 养老金明细
  resources :pension_logs, only: [:index]
  ################################################


  ################################################
  # 小金详细列表
  resources :jajin_logs, only: [:index, :show]

  # 转赠小金
  resources :given_logs, only: [:create]

  # 奖励小金
  resources :reward_logs, only: [:create] do
    collection do
      post 'verify'
    end
  end

  # 扫码赠小金
  resources :jajin_verify_logs, only: [:new, :create] do
    collection do
      post 'verify'
    end
  end

  # 小金转养老金
  resources :exchange_logs, only: [:create]

  # 通联交易列表
  resources :tl_trades, only: [:create]
  # 拉卡拉交易列表
  resources :lakala_trades, only: [:create]

  # 小金消费通知
  resources :consume_messages, only: [:show]
  
  # 会员卡积分转小金
  resources :member_card_point_log, only: [:create, :show, :index]
  ################################################
  resource :verify, only: [:show]


  resources :topics, only: [:create, :show, :index] do
    member do
      post 'add_merchant'
      post 'add_tag'
    end
  end

  resources :tickets, only: [:create]

  resources :jajin_identity_code, only: [:create]
  
  resource :check_merchant do
    member do
      post 'reset'
    end
  end

  resource :check_agent do
    member do
      post 'reset'
    end
  end

  resource :agent do
    member do
      post 'update'
    end
  end

  resources :balance_logs, only: [:create, :index]

  resources :banks, only: [:index]

  resources :bank_card_types, only: [:index]
  
  # 加金兑换的对外网址
  get 'code' => 'jajin_verify_logs#new'
  get 'reward/:verify_code' => 'reward_logs#new'
  
  post 'point_log' => 'member_card_point_log#verify'

  root 'admin/home#index'
  namespace :admin do
    root 'home#index'

    devise_for :agent, :controllers => { 
      :sessions => 'admin/login/sessions' 
    }
    resources :agents do
      collection do
        post 'import'
        get 'logs'
      end
      member do
        get 'upload'
        get 'log'
        get 'down'
      end
    end

    resources :member_card_point_log do
      member do
        # post 'import'
      end
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
