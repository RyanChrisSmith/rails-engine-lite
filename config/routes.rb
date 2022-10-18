Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      get '/merchants/find_all', to: 'search#find_all_merchants'
      get '/items/find', to: 'search#find_item'

      resources :items do
        resources :merchant, only: [:index], controller: :items_merchant
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end
    end
  end

end

