# encoding: utf-8

# Encoding: utf-8
#
# redefined default method
# http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html
module ActionView
  module Helpers
    module NumberHelper

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
          number =  if number.respond_to?('abs')
                      number.abs
                    else
                      number.sub(/^-/, '')
                    end
        end

        # FIXME commented code looks like never working
        # remove it after few monthes
#        begin
          value = number_with_precision(number, options.merge(raise: true))
          format.gsub(/%n/, value).gsub(/%u/, unit).html_safe
=begin
        rescue InvalidNumberError => e
          if options[:raise]
            raise
          else
            formatted_number = format.gsub(/%n/, e.number).gsub(/%u/, unit)
            if e.number.to_s.html_safe?
              formatted_number.html_safe
            else
              formatted_number
            end
          end
        end
=end

      end

    end
  end
end
