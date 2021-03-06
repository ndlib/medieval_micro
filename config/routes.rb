Rails.application.routes.draw do
  root :to => "catalog#index"
  Blacklight.add_routes(self)
  devise_for :users, controllers: { omniauth_callbacks: "admin/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_in', to: redirect("/users/auth/oktaoauth", status: 301), as: :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :users

  namespace 'admin' do
    resources :cities,
              :classifications,
              :collections,
              :countries,
              :date_ranges,
              :facsimiles,
              :languages,
              :libraries,
              :locations,
              :microfilms,
              :roles,
              :users
  end

  get 'admin'          => 'admin/microfilms#index'
  get 'error'          => 'error#test'
  get 'logout'         => 'admin/users#logout'
  get 'users/:id/edit' => 'admin/users#edit', :as => :edit_user_registration_path

  get 'masquerade/start/:user_id' => 'admin/masquerade#start',
    :as => :start_masquerade,
    :via => :get
  get 'masquerade/stop' => 'admin/masquerade#stop',
    :as => :stop_masquerade,
    :via => :get

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
