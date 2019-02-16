Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/home'

  get "/recipes/:urid", to: "recipes#show", as: "recipe"
  get "/recipes/:urid/edit", to: "recipes#edit", as: "edit_recipe"

  resources :recipes, only: [:create, :destroy] do
    patch :update_fragments_positions
    resources :fragments, only: [:index, :create, :update, :destroy] do
      post :add_image
      delete :remove_image
    end
  end
end
