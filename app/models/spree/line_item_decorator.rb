# encoding: utf-8

Spree::LineItem.class_eval do

  # redefine spree/core/app/models/spree/line_item.rb
  def single_money
    current_currency = Spree::Currency.current
    price_in_current_currency = Spree::Currency.convert(price,currency,current_currency.char_code)
    Spree::Money.new(price_in_current_currency, { currency: current_currency })
  end

  # redefine spree/core/app/models/spree/line_item.rb
  def money
    current_currency = Spree::Currency.current
    amount_in_current_currency = Spree::Currency.convert(amount,currency,current_currency.char_code)
    Spree::Money.new(amount_in_current_currency, { currency: current_currency })
  end

  alias display_total money
  alias display_amount money

end
