# frozen_string_literal: true

require 'sidekiq/web'

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Rails.application.secrets.sidekiq_username &&
      password == Rails.application.secrets.sidekiq_password
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    omniauth_callbacks:  'devise_token_auth/custom_omniauth_callbacks'
  }

  resources :users, only: %i[show update] do
    controller 'users' do
      get 'travels', action: 'index_travels'
      get 'authorizations', action: 'index_authorizations'
      get 'favorites', action: 'index_favorites'
      get 'followings', action: 'index_followings'
      get 'followers', action: 'index_followers'
      post 'followers', action: 'create_followers'
      delete 'followers', action: 'destroy_followers'
      get 'image', action: 'show_image'
      put 'image', action: 'update_image'
      patch 'image', action: 'update_image'
      get 'posts', action: 'index_posts'

      collection do
        get 'search'
      end
    end
  end

  resources :travels, only: %i[show create destroy] do
    controller 'travels' do
      get 'authorizations', action: 'index_authorizations'
      get 'favorites', action: 'index_favorites'
      post 'favorites', action: 'create_favorites'
      delete 'favorites', action: 'destroy_favorites'
      get 'comments', action: 'index_comments'
      post 'comments', action: 'create_comments'
      get 'image', aciont: 'show_image'

      collection do
        get 'search'
      end
    end
  end

  resources :comments, only: %i[show] do
    get 'search', on: :collection
  end

  resources :notifications, only: %i[index] do
    post 'read', on: :collection
  end

  get '/home', to: 'home#posts'

  root 'home#root'
end
