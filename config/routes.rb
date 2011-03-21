# Put your extension routes here.
Rails.application.routes.draw do
  match "currency/:id" => "currency#set", :as => :currency
  namespace :admin do
    resources :currencies
    resources :currency_converters
  end
end
