unless Kms.skip_ui
  Kms::Engine.routes.draw do
    devise_for :kms_users,
      class_name: "Kms::User",
      failure_app:  'Kms::Devise::FailureApp',
      module: :devise,
      controllers: { registrations: "users/registrations" }

    constraints(format: "json") do
      resources :templates, except: [:new, :edit], format: true
      resources :snippets, except: [:new, :edit], format: true
      resources :pages, except: [:new, :edit], format: true do
        collection do
          post 'sorting'
        end
      end
      resources :assets, except: [:new, :edit], format: true, as: :kms_assets
      resources :users, only: [:index, :destroy, :update, :show], format: true do
        post :from_kms, on: :collection, action: :create
        get :kms_user, on: :collection
      end
      resources :resources, only: :index, format: true
      resource :settings, only: [:show, :update], format: true

      resources :models, format: true do
        resources :entries, format: true do
          member do
            post '' => 'entries#update'
          end
        end
        resources :fields, only: :update, format: true
      end
    end

    post "/assets/ckeditor" => "assets#ckeditor"

    constraints(format: "html") do
      get "/(*path)" => "kms#index"
    end
  end

  Rails.application.routes.draw do
   root 'kms/public/pages#show'
   get "*path" => "kms/public/pages#show"
   post '/entries/:collection_name' => 'kms/public/entries#create'
  end
end