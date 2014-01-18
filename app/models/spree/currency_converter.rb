# encoding: utf-8

module Spree
  class CurrencyConverter < ActiveRecord::Base
    belongs_to :currency
    default_scope { order('spree_currency_converters.date_req ASC') }

    # attr_accessible :currency_id, :nominal, :value, :date_req, :currency

    class << self
      def add(currency, date, value, nominal)
        create(nominal: nominal, value: value,
               date_req: date, currency: currency)
      end
    end
  end
end
