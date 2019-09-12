Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cuisines, only: [:index]
  resources :matches, only: [:index, :create, :destroy]

  delete '/cuisines/:cuisine_id/destroy_match', to: 'matches#destroy', as: :match_destroy

  resources :favorite_cuisines, only: [:create, :destroy] do
    collection do #removing the ID in the url <> member which shos the ID
      get 'add'
    end
    get 'compare'
    get 'uncompare'
  end

  get 'results', to:'trends#results'
  get 'comparison', to:'pages#comparison'
  get 'map', to:'trends#map'
  get 'graph', to:'trends#graph'
end
