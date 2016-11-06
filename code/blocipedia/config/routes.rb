Rails.application.routes.draw do
  get 'charges/new'
  get 'charges/edit'

  resources :wikis
  
  resources :charges, only: [:new, :create]
  delete '/downgrade', to: 'charges#downgrade'

  root to: "main#index"
    devise_for :users

end
