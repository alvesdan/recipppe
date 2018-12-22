Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'

  resources :recipes, only: [:show, :edit] do
    patch :update_fragments_positions
    resources :fragments, only: [:index, :create, :update, :destroy]
  end
end
