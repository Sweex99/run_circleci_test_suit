Rails.application.routes.draw do
  resources :jobs
  root 'jobs#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
