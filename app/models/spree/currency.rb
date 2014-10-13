# encoding: utf-8

require 'money'

module Spree
  class Currency < ActiveRecord::Base

    has_many :currency_converters do
      def get_rate(date)
        where('date_req <= ?', date).last
      end
    end

    default_scope { order('spree_currencies.locale') }
    scope :locale, ->(str) { where('locale like ?', "%#{str}%") }
    after_save :reset_basic_currency

    # attr_accessible :basic, :locale, :char_code, :num_code, :name

    # FIXME must be transaction
    def basic!
      self.class.update_all(basic: false) && update_attribute(:basic, true)
    end

    def locale=(locales)
      write_attribute(:locale, [locales].flatten.compact.join(','))
    end

    def locale(need_split = true)
      locale_var = read_attribute(:locale).to_s
      if need_split
        locale_var.split(',')
      else
        locale_var
      end
    end

    # We can only have one main currency.
    # Therefore we reset all other currencies but the current if it's the main.
    def reset_basic_currency
      if basic?
        self.class.where("id != ?", id).update_all(basic: false)
      end
    end

    class << self

      # return array of all char_codes
      def all_currencies
        all.map(&:char_code)
      end

      # Get the current locale
      def current(current_locale = nil)
        @current ||= locale(current_locale || I18n.locale).first  || basic
        if @current
          @current
        else
          mess = 'Require load and set default currency'
          mess << '<br/>'
          mess << 'Locale field is factor for determine current currency'
          raise mess
        end
      end

      def current!(current_locale = nil)
        if current_locale.is_a?(Spree::Currency)
          @current = current_locale
        else
          @current = locale(current_locale || I18n.locale).first
        end
      end

      def load_rate(options = {})
        current(options[:locale] || I18n.locale)
        load_rate_from(@current.char_code)
      end

      # load rate for currency(char_code) to basic
      def load_rate_from(from_char_code)
        from_cur = Spree::Currency.find_by_char_code(from_char_code)
        basic = Spree::Currency.basic
        rate = from_cur.currency_converters.get_rate(Time.now)
        if rate
          add_rate(basic.char_code,
                   from_cur.char_code,
                   rate.nominal / rate.value.to_f)
          add_rate(from_cur.char_code,
                   basic.char_code,
                   rate.value.to_f)
        end
      end

      # Exchanges money between two currencies.
      # E.g. with these args: 150, DKK, GBP returns 16.93
      def convert(value, from, to)
        begin
          from_money = ::Money.new(value.to_f * 10000, from)
          res = from_money.exchange_to(to)
          res = (res.to_f / 100).round(2)
        rescue => e
          load_rate_from(from)
          begin
            currency_config = Spree::Config.currency
            res = from_money.exchange_to(currency_config)
            load_rate_from(to)
            res = ::Money.new(res, currency_config).exchange_to(to)
            res = (res.to_f / 100).round(2)
          rescue => e
            raise "Require load actual currency \t\n #{e}"
          end
        end
        res
      end

      # Converts the basic currency value to a 'localized' value.
      # In the parameters you can specify the locale you wish to convert TO.
      # Usage: Currency.conversion_to_current(100, :locale => "da")
      def conversion_to_current(value, options = { })
        load_rate(options)
        convert(value, @basic.char_code, @current.char_code)
      rescue => ex
        error_logger(ex)
        value
      end

      # Converts the currency value of the current locale to the basic currency
      # In the parameters you can specify the locale you wish to convert FROM.
      # Usage: Currency.conversion_from_current(100, :locale => "da")
      def conversion_from_current(value, options = {})
        load_rate(options)
        convert(Monetize.parse(value), @current.char_code, @basic.char_code)
      rescue => ex
        error_logger(ex)
        value
      end

      # write to error log
      # ex - Exception from 'rescue => e'
      def error_logger(ex)
        mes = " [ Currency ] :#{ex.inspect} \n #{ex.backtrace.join('\n ')}"
        Rails.logger.error mes
      end

      # Retrieves the main currency.
      def basic
        @basic ||= where(basic: true).first
      end

      def get(num_code, options = {})
        find_by_num_code(num_code) || create(options)
      end

      private

      def add_rate(from, to, rate)
        ::Money.add_rate(from, to, rate.to_f)
      end

    end

  end
end
