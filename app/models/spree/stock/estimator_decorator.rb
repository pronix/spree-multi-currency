Spree::Stock::Estimator.class_eval do
=begin
   # currency not make sence
   def shipping_methods(package)
     Rails.logger.info package.to_yaml
     shipping_methods = package.shipping_methods
     ship_method = shipping_methods.first
     Rails.logger.info "\t\n\t\n"
     Rails.logger.info ship_method.to_yaml
     Rails.logger.info !ship_method.calculator.available?(package)
     Rails.logger.info !ship_method.include?(order.ship_address)
     shipping_methods.delete_if { |ship_method| !ship_method.calculator.available?(package) }
     shipping_methods.delete_if { |ship_method| !ship_method.include?(order.ship_address) }
     #shipping_methods.delete_if { |ship_method| !(ship_method.calculator.preferences[:currency].nil? || ship_method.calculator.preferences[:currency] == currency) }
     shipping_methods
   end
=end
end

