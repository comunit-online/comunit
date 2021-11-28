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

  concern :search do
    get :search, on: :collection
  end

  concern :stories do
    post 'stories/:slug' => :story, on: :collection, as: :story
  end

  get 'comunit/:table_name/:uuid' => 'network#show', as: nil
  put 'comunit/:table_name/:uuid' => 'network#pull', as: nil

  scope :posts, controller: :posts do
    get '/' => :index, as: :posts
    get ':id-:slug' => :show, as: :post, constraints: { id: /\d+/ }
  end
  resources :authors, only: %i[index show]

  namespace :admin do
    # Comunit component
    resources :sites, concerns: %i[check search toggle]

    # Posts component
    resources :posts, concerns: %i[check search toggle]
    resources :post_groups, concerns: %i[check toggle]
    resources :authors, concerns: %i[check toggle]

    # Taxonomy component
    resources :taxa, concerns: %i[check search toggle]
  end

  namespace :my do
    resources :posts, concerns: %i[check toggle]
  end
end
