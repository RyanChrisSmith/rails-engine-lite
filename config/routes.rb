Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      namespace :merchants do
        get '/find_all', to: 'search#find_all'
      end

      namespace :items do
        get '/find', to: 'search#find_one'
      end

      resources :items do
        resources :merchant, only: [:index], controller: :items_merchant
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end
    end
  end

end

