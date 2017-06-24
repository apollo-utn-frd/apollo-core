# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    omniauth_callbacks:  'devise_token_auth/custom_omniauth_callbacks'
  }

  resources :users, only: [:show, :update] do
    resources :favorites, only: :index
    resources :followers, only: [:index, :create, :destroy]
    resources :followings, only: :index


    scope '/followers' do

    end

    scope '/image' do

    end

    get 'followings', to: 'users#index_followings'


    get 'posts'
    get 'search', on: :collection
    get 'username/:username', to: 'users#username', on: :collection
  end

  resources :travels, only: [:show, :create, :destroy] do
    resources :authorizations, only: :index
    resources :comments, only: [:index, :create]
    resources :favorites, only: [:index, :create, :destroy]

    get 'image'
    get 'search', on: :collection
  end

  resources :comments, only: [:show] do
    get 'search', on: :collection
  end

  resources :notifications, only: [:index] do
    post 'read', on: :collection
  end

  get '/home', to: 'home#posts'

  root 'home#root'
end
