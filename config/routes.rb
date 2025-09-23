Rails.application.routes.draw do
  root "pages#home"
  get "pages/home"

  devise_for :users

  get "stylists/dashboard", to: "stylists#dashboard", as: :stylist_dashboard
  delete "stylists/:id/remove_client", to: "stylists#remove_client", as: :remove_client

  resources :recommendations, only: [:edit, :update]

  resources :stylists, only: [] do
    collection do
      post "create_client", to: "stylists#create_client"
    end
  end

  resources :clients, only: [] do
    member do
      get :mane_vault
    end

    resources :recommendations, only: [:new, :create, :destroy, :index]
  end

  # Products routes (not nested for import)
  resources :products do
    collection { post :import } # adds import_products_path
  end
end
