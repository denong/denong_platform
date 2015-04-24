Rails.application.routes.draw do

  
  devise_ios_rails_for :merchant_users
  devise_ios_rails_for :users
  
  resources :sms_tokens, only: [:create]
  resources :pension, only: [:index]
  
  resources :jajin, only: [:index]
  resources :identity_verifies, only: [:create, :update, :index]
  resources :merchants, only: [:index, :show] do
    resources :shops, only: [:index, :new, :create]
    collection do
      get 'customer_index'
    end
  end
  resources :shops, only: [:index, :show] do
    member do
      post 'follow'
      post 'unfollow'
    end
    collection do
      post 'neighbour_shop' 
    end
  end
  resources :customer_reg_infos, only: [:show, :update]
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
  # 养老金收益相关路由
  resources :gain_accounts, only: [:index, :show] do
    resources :gain_histories, only: [:index, :show]
  end
  ################################################


  ################################################
  # 加金详细列表
  resources :jajin_logs, only: [:index, :show]

  # 转赠加金
  resources :given_logs, only: [:create]

  # 扫码赠加金
  resources :jajin_verify_logs, only: [:create]  

  # 加金转养老金
  resources :exchange_logs, only: [:create]

  # 通联交易列表
  resources :tl_trades, only: [:create]
  
  ################################################


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
