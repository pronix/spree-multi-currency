Spree::Stock::Estimator.class_eval do

   # currency not make sence
   # redefined spree/core/app/models/spree/stock/estimator.rb
   def shipping_methods(package)
     shipping_methods = package.shipping_methods
     shipping_methods.delete_if { |ship_method| !ship_method.calculator.available?(package) }
     shipping_methods.delete_if { |ship_method| !ship_method.include?(order.ship_address) }
     # may be i something miss, but looks like should be
     # deleted shipping method only if calculator have NOT currency
     shipping_methods.delete_if { |ship_method| ship_method.calculator.preferences[:currency].nil? }
     # shipping_methods.delete_if { |ship_method| !(ship_method.calculator.preferences[:currency].nil? || ship_method.calculator.preferences[:currency] == currency) }
     shipping_methods
   end

end

