# encoding: utf-8

require 'money'

module Spree
  class Currency < ActiveRecord::Base

    has_many :currency_converters do
      def get_rate(date)
        last(:conditions => ["date_req <= ?", date])
      end
    end

    default_scope :order => "spree_currencies.locale"
    scope :locale, lambda{|str| where("locale like ?", "%#{str}%")}
    after_save :reset_basic_currency

    attr_accessible :basic, :locale, :char_code, :num_code, :name

    def basic!
      self.class.update_all(:basic => false) && update_attribute(:basic, true)
    end

    def locale=(locales)
      write_attribute(:locale, [locales].flatten.compact.join(','))
    end

    def locale(need_split = true)
      need_split ? read_attribute(:locale).to_s.split(',') : read_attribute(:locale).to_s
    end

    # We can only have one main currency.
    # Therefore we reset all other currencies but the current if it's the main.
    def reset_basic_currency
      self.class.where("id != ?", self.id).update_all(:basic => false) if self.basic?
    end

    class << self

      # Get the current locale
      def current( current_locale = nil )
        @current ||= locale(current_locale || I18n.locale).first
      end

      def current!(current_locale = nil )
        @current = current_locale.is_a?(Spree::Currency) ? current_locale : locale(current_locale||I18n.locale).first
      end

      def load_rate(options= {})
        current(options[:locale] || I18n.locale)
        load_rate_from(@current.char_code)
      end

      # load rate for currency(char_code) to basic
      def load_rate_from(from_char_code)
        from_cur = Spree::Currency.find_by_char_code(from_char_code)
        basic = Spree::Currency.basic
        rate = from_cur.currency_converters.get_rate(Time.now)
        if rate
          add_rate(basic.char_code,   from_cur.char_code, rate.nominal/rate.value.to_f)
          add_rate(from_cur.char_code, basic.char_code,   rate.value.to_f)
        end
      end

      # Exchanges money between two currencies.
      # E.g. with these args: 150, DKK, GBP returns 16.93
      def convert(value, from, to)
        begin
          res = ::Money.new(value.to_f * 10000, from).exchange_to(to)
        rescue => e
          load_rate_from(from)
          res = ::Money.new(value.to_f * 10000, from).exchange_to(Spree::Config.currency)
          res = ::Money.new(res, Spree::Config.currency).exchange_to(to)
        end
        res = (res.to_f / 100).round(2)
        res
      end

      # Converts the basic currency value to a 'localized' value.
      # In the parameters you can specify the locale you wish to convert TO.
      # Usage: Currency.conversion_to_current(100, :locale => "da")
      def conversion_to_current(value, options = { })
        load_rate(options)
        convert(value, @basic.char_code, @current.char_code)
      rescue => ex
        Rails.logger.error " [ Currency ] :#{ex.inspect} \n #{ex.backtrace.join('\n ')}"
        value
      end

      # Converts the currency value of the current locale to the basic currency.
      # In the parameters you can specify the locale you wish to convert FROM.
      # Usage: Currency.conversion_from_current(100, :locale => "da")
      def conversion_from_current(value, options={})
        load_rate(options)
        convert(parse_price(value), @current.char_code, @basic.char_code)
      rescue => ex
        Rails.logger.error " [ Currency ] :#{ex.inspect} \n #{ex.backtrace.join('\n ')}"
        value
      end

      def parse_price(price)
        return price unless price.is_a?(String)

        separator, delimiter = I18n.t([:'number.currency.format.separator', :'number.currency.format.delimiter'])
        non_price_characters = /[^0-9\-#{separator}]/
        price.gsub!(non_price_characters, '') # strip everything else first
        price.gsub!(separator, '.') unless separator == '.' # then replace the locale-specific decimal separator with the standard separator if necessary

        price.to_d
      end

      # Retrieves the main currency.
      def basic
        @basic ||= where(:basic => true).first
      end

      def get(num_code, options ={ })
        find_by_num_code(num_code) || create(options)
      end

      private

      def add_rate(from, to, rate)
        ::Money.add_rate(from, to, rate.to_f )
      end

    end

  end
end
