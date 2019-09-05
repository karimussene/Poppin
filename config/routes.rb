Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :cuisines, only: [:index]
  resources :favorite_cuisines, only: [:create]
  get 'results', to:'trends#results'
  get 'comparison', to:'pages#comparison'
  get 'map', to:'pages#map'

end
