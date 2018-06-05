Rails.application.routes.draw do
  get 'searches/new'
  get 'searches/create'
  get 'articles/index'
  get 'articles/show'
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
