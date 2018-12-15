# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.set :session_secret, Rails.application.secrets.secret_key_base

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    secrets = Rails.application.secrets

    secure_compare_username = ActiveSupport::SecurityUtils.secure_compare(secrets.sidekiq_username, username)
    secure_compare_password = ActiveSupport::SecurityUtils.secure_compare(secrets.sidekiq_password, password)

    secure_compare_username && secure_compare_password
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: %i[create destroy]

  resources :users, only: %i[show edit update] do
    controller 'users' do
      post 'validate'
      get 'travels', action: 'index_travels'
      get 'authorizations', action: 'index_authorizations'
      get 'favorites', action: 'index_favorites'
      get 'followings', action: 'index_followings'
      get 'followers', action: 'index_followers'
      post 'followers', action: 'create_followers'
      delete 'followers', action: 'destroy_followers'
      put 'image', action: 'update_image'
      patch 'image', action: 'update_image'
      get 'posts', action: 'index_posts'

      collection do
        get 'search'
      end
    end
  end

  resources :travels, only: %i[show create destroy new] do
    controller 'travels' do
      get 'authorizations', action: 'index_authorizations'
      get 'favorites', action: 'index_favorites'
      post 'favorites', action: 'create_favorites'
      delete 'favorites', action: 'destroy_favorites'
      get 'comments', action: 'index_comments'
      post 'comments', action: 'create_comments'

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

  get '/home', to: 'home#home'
  get '/posts', to: 'home#posts'

  root 'home#root'
end
