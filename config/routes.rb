Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'

  resources :recipes, only: [:show, :create, :edit, :destroy] do
    patch :update_fragments_positions
    resources :fragments, only: [:index, :create, :update, :destroy] do
      post :add_image
      delete :remove_image
    end
  end
end
