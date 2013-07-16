Spree::Variant.class_eval do
  extend Spree::MultiCurrency
  multi_currency :cost_price

  # prices stored in spree_prices
  def price
    basic = Spree::Currency.basic.char_code
    price = prices.where(currency: basic).limit(1)[0]
    if price
      amount = price.amount
    else
      amount = read_attribute(:price) || 0
    end
    Spree::Currency.conversion_to_current(amount)
  end

  def base_price
    price
  end

  # assign price
  def price=(value)
    basic = Spree::Currency.basic.char_code
    base_price = prices.where(currency: basic).limit(1)[0]
    value = Spree::Currency.conversion_from_current(value)
    if base_price
      base_price.amount = value
    else
      if !new_record?
        prices.create(amount: value,currency: basic)
      else
        write_attribute(:price, value)
      end
    end
  end

end

Spree::Money.class_eval do
  def initialize(amount, options={})
    @money = ::Money.parse([amount, (Spree::Currency.current.char_code)].join)
    @options = {}
    @options[:with_currency] = true if Spree::Config[:display_currency]
    @options[:symbol_position] =  Spree::Config[:currency_symbol_position].to_sym
    @options[:no_cents] = true if Spree::Config[:hide_cents]
    @options.merge!(options)
    # Must be a symbol because the Money gem doesn't do the conversion
    @options[:symbol_position] = @options[:symbol_position].to_sym
   end
end
