Rails.application.routes.draw do
  namespace :v1 do
    resources :performances, only: [:create] do
      get 'check_indicator', on: :collection
    end
  end
end
