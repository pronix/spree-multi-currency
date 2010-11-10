require 'spree_core'
require 'multi_currencies_hooks'

module MultiCurrencies
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
      Variant.class_eval do

        def price
          Currency.conversion_to_current(read_attribute(:price))
        end

        def price=(value)
          conversion_value = Currency.conversion_from_current(value)
          write_attribute(:price, conversion_value)
        end

      end



      Order.class_eval do
        def total
          Currency.conversion_to_current(read_attribute(:total))
        end

        def total=(value)
          conversion_value = Currency.conversion_from_current(value)
          write_attribute(:total, conversion_value)
        end

        def item_total
          Currency.conversion_to_current(read_attribute(:item_total))
        end

        def item_total=(value)
          conversion_value = Currency.conversion_from_current(value)
          write_attribute(:item_total, conversion_value)
        end

        def credit_total
          Currency.conversion_to_current(read_attribute(:credit_total))
        end

        def credit_total=(value)
          conversion_value = Currency.conversion_from_current(value)
          write_attribute(:credit_total, conversion_value)
        end


      end

      LineItem.class_eval do
        def price
          Currency.conversion_to_current(read_attribute(:price))
        end

        def price=(value)
          conversion_value = Currency.conversion_from_current(value)
          write_attribute(:price, conversion_value)
        end
      end

    end

    config.to_prepare &method(:activate).to_proc
  end
end
