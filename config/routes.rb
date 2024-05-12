Rails.application.routes.draw do
  namespace :v1 do
    resources :performances, only: [:create] do

      collection do
        get 'check_indicator'
        get 'top_performers'
      end
    end
  end
end
