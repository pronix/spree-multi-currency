# encoding: utf-8

# Encoding: utf-8
#
# redefined default method
# http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html
module ActionView
  module Helpers
    module NumberHelper
      DEFAULT_CURRENCY_VALUES = { format: '%u%n',
                                  negative_format: '-%u%n',
                                  unit: '$',
                                  separator: '.',
                                  delimiter: ',',
                                  precision: 2,
                                  significant: false,
                                  strip_insignificant_zeros: false }

      def number_to_currency(number, options = {})
        return nil if number.nil?
        options.symbolize_keys!
        currency_char = Spree::Currency.current.try(:char_code) ||
                        I18n.default_locale
        options[:locale] = "currency_#{ currency_char }"
        defaults  = I18n.translate('number.format',
                                   locale: options[:locale],
                                   default: {})
        currency  = I18n.translate('number.currency.format',
                                   locale: options[:locale],
                                   default: {})
        defaults  = DEFAULT_CURRENCY_VALUES.merge(defaults).merge!(currency)
        defaults[:negative_format] = '-%n %u'
        options   = defaults.merge!(options)

        unit      = options.delete(:unit)
        format    = options.delete(:format)

        if number.to_f < 0
          format = options.delete(:negative_format)
          number = number.abs
        end

        value = number_with_precision(number, options.merge(raise: true))
        format.gsub(/%n/, value).gsub(/%u/, unit).html_safe

      end

    end
  end
end
