Rails.application.routes.draw do
  root 'tasks#index'

  get '/tasks', to: 'tasks#index'
  post '/tasks', to: 'tasks#create'
  get '/tasks/:id', to: 'tasks#show'
  put '/tasks/:id', to: 'tasks#update'
  delete '/tasks/:id', to: 'tasks#destroy'
  
end
