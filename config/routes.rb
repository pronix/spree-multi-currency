# Put your extension routes here.
Spree::Core::Engine.routes.prepend do
  match "currency/:id" => "currency#set", :as => :currency
  namespace :admin do
    resources :currencies
    resources :currency_converters
  end
end
