Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :groups, only: [:index, :create]
      resources :orders, only: [:index, :create]

      get 'users/sign_up'
      post 'users/sign_in'
      post 'users/sign_up'
    end
  end
end
