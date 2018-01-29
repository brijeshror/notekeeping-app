Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, {
    controllers: { sessions: "users/devise/sessions" }
  }
  resources :notes do
    resources :note_shares do
    end
  end
end
