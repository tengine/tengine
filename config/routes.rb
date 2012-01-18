TengineConsole::Application.routes.draw do
  if TengineConsole.test_console?
    namespace :tengine do  namespace :test do resources :scripts end end
  end

  namespace :tengine do  namespace :resource do resources :virtual_server_types end end

  namespace :tengine do  namespace :resource do resources :physical_servers end end

  namespace :tengine do
    namespace :resource do
      resources :virtual_servers do |v|
        delete '', :on => :collection, :action => 'destroy_all'
        get 'created', :on => :collection
      end
    end
  end

  namespace :tengine do  namespace :core do resources :settings end end

  namespace :tengine do  namespace :job do resources :executions end end

  namespace :tengine do  namespace :job do resources :categories end end

  namespace :tengine do
    namespace :job do
      resources :root_jobnet_actuals do
        resources :jobnet_actuals
        member{ get :vertecs }
      end
    end
  end

  namespace :tengine do  namespace :job do resources :root_jobnet_templates end end

  namespace :tengine do  namespace :job do resources :jobnets end end

  namespace :tengine do
    namespace :job do
      resources :jobnets do
        resources :edges
      end
    end
  end

  namespace :tengine do  namespace :job do resources :edges end end

  namespace :tengine do  namespace :job do resources :vertices end end

  namespace :tengine do  namespace :job do resources :jobs end end

  namespace :tengine do  namespace :job do resources :expansions end end

  namespace :tengine do  namespace :job do resources :jobnet_templates end end

  namespace :tengine do  namespace :resource do  namespace :provider do resources :ec2s end end end

  namespace :tengine do  namespace :resource do resources :credentials end end

  namespace :tengine do  namespace :resource do resources :virtual_server_images end end

  namespace :tengine do  namespace :resource do resources :providers end end

  namespace :tengine do  namespace :resource do resources :servers end end

  get "tengine/core/event_ignitions/new"

  post "tengine/core/event_ignitions/fire"

  namespace :tengine do  namespace :core do resources :sessions end end

  namespace :tengine do  namespace :core do resources :handler_paths end end

  namespace :tengine do  namespace :core do resources :events end end

  namespace :tengine do
    namespace :core do
      resources :drivers do
        resources :handlers
      end
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
