Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :rewards, only: [:index] do
    collection do
      post :calculate_rewards
    end
  end
end
