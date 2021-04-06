# frozen_string_literal: true

Rails.application.routes.draw do
  get 'comunit/:table_name/:uuid' => 'network#show', as: nil
  put 'comunit/:table_name/:uuid' => 'network#pull', as: nil
end
