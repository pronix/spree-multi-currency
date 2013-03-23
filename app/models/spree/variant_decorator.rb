Spree::Variant.class_eval do
  extend Spree::MultiCurrency
  multi_currency :price, :cost_price
  def price_in(currency)
    # will use internal currency, parametr will ignored
    currency = Spree::Currency.current
    prices.select{ |price| price.currency == currency }.first || Spree::Price.new(:variant_id => self.id, :currency => currency, :amount => self.cost_price)
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
