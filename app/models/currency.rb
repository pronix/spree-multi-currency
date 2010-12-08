class Currency < ActiveRecord::Base
  has_many :currency_converters
  class << self
    # Текущая валюта определенная по текущей локали
    def current(_locale=I18n.locale)
      find_by_locale(_locale.to_s)
    end

    # Конвертируем сумму к валюте текущей локале
    # Если валюта или локаль не найдена то возвращается та же сумма
    #
    def conversion_to_current(price, options = { })
      return price if price.to_f <= 0.0
      _locale = options[:locale] || I18n.locale
      _date = options[:date] || Time.now
      return price if current(_locale).nil? || current(_locale).basic?
      current_currency = current(_locale).currency_converters.last(:conditions => ["date_req <= ?", _date])
      return price if current_currency.blank?
      (price.to_f / current_currency.value.to_f) * current_currency.nominal.to_i
    end

    # Конвертируем значение из валюты текущей локали к основной валюте
    # в параметрах можно указать локаль из которой можно делать конвертацияю :locale
    # и дату курса :date, курс берется последний найденный до указанной даты
    #
    def conversion_from_current(value, options={})
      return value if value.to_f <= 0.0
      _locale = options[:locale] || I18n.locale
      _date = options[:date] || Time.now
      return value if current(_locale).nil? || current(_locale).basic?
      current_currency = current(_locale).currency_converters.last(:conditions => ["date_req <= ?", _date])
      return value if current_currency.blank?
      return (value.to_f / current_currency.nominal.to_f ) * current_currency.value
    end

    # Основная валюта
    def basic
      first(:conditions => { :basic => true })
    end

    def get(num_code, options ={ })
      find_by_num_code(num_code) || create(options)
    end
  end
end
