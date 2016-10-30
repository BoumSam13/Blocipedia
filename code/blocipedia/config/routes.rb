Rails.application.routes.draw do
  resources :wikis

  root to: "main#index"
    devise_for :users

end
