# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  resources :projects do
    scope module: :projects do
      resources :comments, only: [:create]
      resources :comment_forms, only: [:create]
      resources :status_changes, only: [:create]
    end
  end

  root to: "projects#index"
end
