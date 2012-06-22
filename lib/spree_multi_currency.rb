require 'spree/core'
require 'spree_multi_currency/engine'
module Spree::MultiCurrency

  # Order.class_eval do
  # extend MultiCurrency
  # multi_currency :item_total, :total,
  #                :rate_at_date => lambda{ |t| t.created_at },
  #                :only_read => true
  #  only_read - выполнять перевод из одной валюты в другую только для вывода
  #  rate_at_date - использовать курс валюты на дату
  def multi_currency(*args)
    options = args.extract_options!
    [args].flatten.compact.each do |number_field|
      define_method(number_field.to_sym) do
        if options.has_key?(:rate_at_date) && options[:rate_at_date].is_a?(Proc)
          Currency.conversion_to_current(
          	read_attribute(number_field.to_sym),
          	{ :date => options[:rate_at_date].call(self) }
          )
        else
          Currency.conversion_to_current(read_attribute(number_field.to_sym))
        end
      end

      define_method("base_#{number_field}") do
        read_attribute(number_field.to_sym)
      end

      unless options[:only_read]
        define_method(:"#{number_field}=") do |value|
          write_attribute(number_field.to_sym, Currency.conversion_from_current(value))
        end
      end

    end
  end
end

