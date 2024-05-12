Rails.application.routes.draw do
  namespace :v1 do
    resources :performances, only: [:create]
  end
end
