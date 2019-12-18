Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'todos#index'
  #patch 'todos/:id/completed' => 'todos#completed', as: "completed_todo"
  #put 'todos/:id/' => 'todos#completed'
  resources :todos
  resources :tags
end
