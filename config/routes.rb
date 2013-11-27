Biogasdata::Application.routes.draw do

  devise_for :users

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  #Field Api
  mount Field::API => '/field/'

  #Dashboard
  get 'dashboard/login'

  #XHR Paths
  match 'dashboard/user' => 'dashboard#read_current_user'
  match 'dashboard/customers' => 'dashboard#read_customers'
  match 'dashboard/locations' => 'dashboard#read_locations'
  match 'dashboard/flaredeployments' => 'dashboard#read_flare_deployments'
  match 'dashboard/flarespecifications' => 'dashboard#read_flare_specifications'
  match 'dashboard/flaremonitordata' => 'dashboard#read_flare_monitor_data'
  match 'dashboard/constraints' => 'dashboard#create_session'

  #Data Input
  match 'data_input/create', :to => 'data_input#create', :as => 'data_input_create'
  match 'data_input/import', :to => 'data_input#import', :as => 'data_input_import'

  #Mobile Rig
  match 'mobile_rig', :to => 'mobile_rig#index', :as => 'mobile_rig_index'
  match 'api/documentation', :to => 'mobile_rig#documentation', :as => 'api_documentation'

  root :to => 'dashboard#login'
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

  # You can have the root of your site routed with 'root'
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with 'rake routes'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
