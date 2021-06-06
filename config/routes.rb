Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { registrations: "users/registrations" }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    get 'new_profile', to: 'users/registrations#new_profile'
    post 'new_profile', to: 'users/registrations#new_profile'
    post 'check_profile', to: 'users/registrations#check_profile'
    post 'profiles', to: 'users/registrations#create_profile'
  end  

  resources :users, only: [:show, :edit, :update] do
    # resources :relationships, only: [:create, :destroy]
    resources :rooms, only: [:show, :index]

    member do
      get 'articles/show_article', to: "articles#show_article" 
      get 'likes/show', to: "likes#show", as: "like"
      get 'relationships/show_following', to: "relationships#show_following", as: "following"
      get 'relationships/show_follower', to: "relationships#show_follower", as: "follower"

      post 'relationships/create', to: "relationships#create", as: "create"
      delete 'relationships/destroy', to: "relationships#destroy", as: "destroy"
    end
  end
  
  resources :articles do
    collection do
      get "create_done"
      get "search"
    end

    member do
      get "update_done"
      get "destroy_caution"      
      get "destroy_done"
      get "comments/destroy", to: "comments#destroy", as: "comment_destroy"
    end

    resources :comments, only: [:create]
  end

  root to: 'articles#index'

  post 'likes/:id/create', to: "likes#create", as: 'create_like'
  delete 'likes/:id/destroy', to: "likes#destroy", as: 'destroy_like'

  post 'articles/attach', to: 'articles#attach'

  resources :tags do
    get "articles", to: "articles#tag_search"
  end

end
