Rails.application.routes.draw do

  get 'sessions/new'

  root 'pages#home'
  get 'home' => 'pages#home'
  get 'contact' => 'pages#contact'
  get 'about' => 'pages#about'
  get 'hire' => 'pages#hire'
  get 'help' => 'pages#help'

  get 'signup' => 'users#new'

  resources :users
  get '/trip' => 'users#tripList'
  get '/manage/trip' => 'users#tripManage'
  
  resources :sessions
  get 'signin' => 'sessions#new'
  delete 'signout' => 'sessions#destroy'

  resources :hotels
  post '/hotels/order' => 'hotels#order'
  delete '/hotelsOrder' => 'hotels#destroyOrder'

  
  resources :cars
  post '/cars/order' => 'cars#order'
  delete '/carsOrder' => 'cars#destroyOrder'
  
  resources :flights
  post '/flights/order' => 'flights#order'
  delete '/flightsOrder' => 'flights#destroyOrder'

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
