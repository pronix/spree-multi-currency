class Currency < ActiveRecord::Base
  has_many :currency_converters

  def basic!
    update_attribute(:basic, true)
  end
  class << self
    # Текущая валюта определенная по текущей локали
    def current(_locale=I18n.locale)
      find_by_locale(_locale.to_s)
    end

    # Конвертируем сумму к валюте текущей локале
    # Если валюта или локаль не найдена то возвращается та же сумма
    # Money.new(value.to_f, "Основаня").exchange_to("К Текущей").to_f
    #
    def conversion_to_current(value, options = { })
      if current_currency = check_current_currency(value, options)
        (value.to_f / current_currency.value.to_f) * current_currency.nominal.to_i
      else
        value
      end
    end

    # Конвертируем значение из валюты текущей локали к основной валюте
    # в параметрах можно указать локаль из которой можно делать конвертацияю :locale
    # и дату курса :date, курс берется последний найденный до указанной даты
    # Money.new(value.to_f, "Текущая локаль").exchange_to("К Основной").to_f
    #
    def conversion_from_current(value, options={})
      if current_currency = check_current_currency(value, options)
        (value.to_f / current_currency.nominal.to_f ) * current_currency.value
      else
        value
      end
    end


    def check_current_currency(value, options)
      return nil if value.to_f <= 0.0
      @locale, @date = (options[:locale] || I18n.locale), (options[:date] || Time.now)
      return nil if current(@locale).nil? || current(@locale).basic?
      current_currency = current(@locale).currency_converters.last(:conditions => ["date_req <= ?", @date])
      current_currency.blank? ? nil : current_currency
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
