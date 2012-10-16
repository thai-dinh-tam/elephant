ElephantWebApp::Application.routes.draw do


    root to: 'static_pages#home'

    match '/help', to: 'static_pages#help'
    match '/about', to: 'static_pages#about'
    match '/sales', to: 'static_pages#sales'

    resources :users, only: [:index, :show, :new, :create, :destroy, :edit, :update]

    get 'settings', to: 'users#settings', as: 'settings'


    resources :sessions, only: [:create, :destroy]

    match '/signin', to: 'sessions#new'
    get '/update_password', to: 'sessions#edit'
    match '/create_password', to: 'sessions#update', via: :post
    match '/signout', to: 'sessions#destroy', via: :delete

    resources :elephant_admin, only: [:index]
    match '/elephant_admin', to: 'elephant_admin#index'

    resources :companies, only: [:new, :destroy, :create, :show]
    get 'company', to: 'companies#show', as: 'company'

    resources :job_templates, only: [:index, :new, :create, :destroy, :show, :edit, :update]

    resources :clients, only: [:index, :new, :create, :destroy, :show, :edit, :update]

    resources :districts, only: [:index, :new, :create, :destroy, :show, :edit, :update]

    resources :product_lines, only: [:new, :create, :edit, :update, :destroy]

    resources :documents, only: [:new, :create, :update, :destroy]

    resources :dynamic_fields, only: [:new, :create, :update, :destroy]

end
