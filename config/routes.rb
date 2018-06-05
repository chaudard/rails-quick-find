Rails.application.routes.draw do
  root to: 'pages#home'
  resources :searches, only: [:new, :create] do
    resources :articles, only: [:index, :show]
  end

end
