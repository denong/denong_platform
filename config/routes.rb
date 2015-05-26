Rails.application.routes.draw do

  devise_ios_rails_for :merchant_users  

  resources :sms_tokens, only: [:create]
  resources :pension, only: [:index]
  
  resources :jajin, only: [:index]
  
  resources :merchants, only: [:index, :show, :update] do
    resources :shops, only: [:index, :new, :create]
    collection do
      get 'customer_index'
    end
    member do
      post 'add_tag'
      get 'get_followers'
      post 'follow'
      post 'unfollow'
    end
  end
  resource :merchant, only: [:show]

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
    member do
      post 'bind'
    end
  end
  
  resources :yl_trades, only: [:create, :index, :show]
  resources :merchant_messages, only: [:create, :index]
  resources :merchant_giving_logs, only: [:index, :show]

  resources :bank_cards, only: [:index, :create] do
    collection do
      post 'send_msg'
    end
  end

  resource :merchant_sys_reg_info


  ################################################ 
  # 用户相关的路由
  devise_ios_rails_for :users

  # 用户注册资料
  resources :customer_reg_infos, only: [:show]
  resource :customer_reg_info, only: [:show, :update]

  # 用户认证
  resources :identity_verifies, only: [:create, :update, :index]

  # 用户是否存在
  resource :check_user, only: [:show] do
    member do
      post 'reset'
    end
  end
  ################################################

  ################################################
  # 养老金收益相关路由
  resources :gain_accounts, only: [:index, :show] do
    resources :gain_histories, only: [:index, :show]
  end
  ################################################


  ################################################
  # 小金详细列表
  resources :jajin_logs, only: [:index, :show]

  # 转赠小金
  resources :given_logs, only: [:create]

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
  
  ################################################
  resource :verify, only: [:show]


  resources :topics, only: [:create, :show, :index] do
    member do
      post 'add_merchant'
      post 'add_tag'
    end
  end

  resources :tickets, only: [:create]
  # 加金兑换的对外网址
  get 'code' => 'jajin_verify_logs#new'

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
