# Put your extension routes here.

map.namespace :admin do |admin|
  admin.resources :currencies
  admin.resources :currency_converters
end
