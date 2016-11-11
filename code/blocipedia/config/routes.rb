Rails.application.routes.draw do
  get 'charges/new'
  get 'charges/edit'

  resources :wikis do
    resources :collaborators
  end
  
  resources :charges, only: [:new, :create]
  delete '/downgrade', to: 'charges#downgrade'

  root to: "main#index"
    devise_for :users

end
