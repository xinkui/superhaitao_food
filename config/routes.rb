Superhaitao::Application.routes.draw do

  namespace :shipping do

    namespace :admin do

      resources :brands

      resources :categories

      resources :weights

      resources :prices

      resources :skus do
        collection do
          match 'search' => 'skus#index', via: [:get, :post], as: :search
          put 'get_sku_ajax'
        end
      end

      resources :items do
        collection do
          match 'search' => 'items#index', via: [:get, :post], as: :search
          get 'checked_item'
        end
      end

      resources :orders do
        collection do
          match 'search' => 'orders#index', via: [:get, :post], as: :search
          get   'get_receiver_pdf'
          get   'show_checked_order'
          patch  'checked_order'
          get   'show_ship_order'
          patch  'ship_order'
          get   'add_share_point'
        end
      end

    end

    namespace :buyer do
      resources :receivers

      resources :items

      resources :orders do
        collection do
          post 'save_order'
          post 'fix_order'
          get  'pre_create'
          get  'open_payment_page'
          post 'payment'
          get  'complete_payment_from_alipay'
          post 'notify_url_from_alipay'
          get  'confirm'
          put  'cal_order_total_price_ajax'
        end
      end

      resources :helps do
        collection do
          get 'cancan_error'
          get 'index'
          get 'shopping_guide'
          get 'shopping_guide_amazon'
          get 'shopping_guide_windeln'
          get 'shopping_guide_mytime'
          get 'shopping_guide_allyouneed'
          get 'shopping_guide_bodyguard'
          get 'superhaitao_guide'
          get 'price_guide'
          get 'point_guide'
          get 'tax_guide'
          get 'goods_guide'
          get 'package_guide'
          get 'shipping_protocol'
          get 'embargo_list'
        end
      end

    end

  end

  namespace :users do
    resources :manager do
      collection do
        get 'edit'
        patch 'update'
        match 'search' => 'manager#index_admin', via: [:get, :post], as: :search_users
        get 'new_admin'
        patch 'update_admin'
        post 'create_admin'
        get 'add_share_point'
        get 'show_admin'
        get 'edit_admin'
        get 'change_state_admin'
      end
    end
  end

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  root 'home#index'

  resources :news

end
