# frozen_string_literal: true

Rails.application.routes.draw do
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  root 'index#index'

  get 'comunit/:table_name/:uuid' => 'network#show', as: nil
  put 'comunit/:table_name/:uuid' => 'network#pull', as: nil

  namespace :admin do
    resources :sites, concerns: %i[check toggle]
    resources :posts, concerns: %i[check toggle]
  end
end
