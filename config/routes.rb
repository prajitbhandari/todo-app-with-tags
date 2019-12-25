Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'todos#index'
  #put '/todos/:id', to: 'todos#recover', as: 'recover_todos'
  resources :todos do
    member do
      put 'recover'
      delete 'purge'
    end
  end
  resources :tags
end
