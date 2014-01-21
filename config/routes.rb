# encoding: utf-8

# Put your extension routes here.
Spree::Core::Engine.add_routes do
  get 'currency/:id' => 'currency#set', as: :currency
  namespace :admin do
    resources :currencies
    resources :currency_converters
  end
end
