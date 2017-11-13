Rails.application.routes.draw do
  root to: 'facilities#index'

  resources :facilities do
    resources :units, :synchronizations
  end
end
