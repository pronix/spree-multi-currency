# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class MultiCurrencyExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/multi_currency"

  # Please use multi_currency/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end

  def activate

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
    Variant.class_eval do

      def price
        Currency.conversion_to_current(read_attribute(:price))
      end

      def price=(value)
        conversion_value = Currency.conversion_from_current(value)
        write_attribute(:price, conversion_value)
      end

    end
  end
end
