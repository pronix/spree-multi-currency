Spree::Stock::Estimator.class_eval do

   # currency not make sence
   # redefined spree/core/app/models/spree/stock/estimator.rb
   # may be i something miss, but looks like should be
   # deleted shipping method if calculator have NOT currency
   def shipping_methods(package)
     shipping_methods = package.shipping_methods
     shipping_methods.delete_if do |ship_method|
       !ship_method.calculator.available?(package) ||
       !ship_method.include?(order.ship_address) ||
       ship_method.calculator.preferences[:currency].nil?
     end
     shipping_methods
   end

end

