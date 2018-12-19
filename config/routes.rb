Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'

  resources :recipes, only: [:show] do
    resources :fragments, only: [:index]
  end
end
