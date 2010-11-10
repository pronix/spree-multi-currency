# Put your extension routes here.
Rails.application.routes.draw do
  namespace :admin do
    resources :currencies
    resources :currency_converters
  end
end
