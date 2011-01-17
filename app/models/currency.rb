require "money"
class Currency < ActiveRecord::Base

  has_many :currency_converters do
    def get_rate(date)
      last(:conditions => ["date_req <= ?", date])
    end
  end

  # cattr_accessor :current
  scope :locale, lambda{|str| where("locale like ?", "%#{str}%")}

  def basic!
    self.class.update_all(:basic => false) && update_attribute(:basic, true)
  end

  class << self

    def load_rate(options= {})
      @_locale    = options[:locale]  || I18n.locale
      @_date_rate = options[:date]    || Time.now
      @basic      ||= basic
      @current    ||= locale(@_locale).first

      unless Money.default_bank.get_rate(@basic.char_code, @current.char_code)
        if @rate = @current.currency_converters.get_rate(@_date_rate)
          Money.add_rate(@basic.char_code, @current.char_code, @rate.nominal/@rate.value.to_f )
        end
      end

      unless Money.default_bank.get_rate(@current.char_code, @basic.char_code)
        if @rate = @current.currency_converters.get_rate(@_date_rate)
          Money.add_rate(@current.char_code, @basic.char_code, @rate.value.to_f )
        end
      end

    end

    def convert(value, from, to)
      Money.new(value.to_f * 100, from).exchange_to(to).to_f
    end

    # Конвертируем сумму к валюте текущей локале
    # Если валюта или локаль не найдена то возвращается та же сумма
    # Money.new(value.to_f, "Основаня").exchange_to("К Текущей").to_f
    #Currency.conversion_to_current(100, :locale => "ru")
    def conversion_to_current(value, options = { })
      load_rate(options)
      convert(value, @basic.char_code, @current.char_code)
    end

    # Конвертируем значение из валюты текущей локали к основной валюте
    # в параметрах можно указать локаль из которой можно делать конвертацияю :locale
    # и дату курса :date, курс берется последний найденный до указанной даты
    #Currency.conversion_from_current(100, :locale => "ru")
    def conversion_from_current(value, options={})
      load_rate(options)
      convert(value,  @current.char_code, @basic.char_code)
    end


    # Основная валюта
    def basic
      @basic ||= first(:conditions => { :basic => true })
      @basic
    end

    def get(num_code, options ={ })
      find_by_num_code(num_code) || create(options)
    end
  end

end
