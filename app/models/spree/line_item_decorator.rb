# encoding: utf-8

Spree::LineItem.class_eval do

  # redefine spree/core/app/models/spree/line_item.rb
  def single_money
    calculate_money(price)
  end

  # redefine spree/core/app/models/spree/line_item.rb
  def money
    calculate_money(amount)
  end

  def calculate_money(var)
    current_cur = Spree::Currency.current
    var_in_current_currency = Spree::Currency.convert(var,
                                                      currency,
                                                      current_cur.char_code)
    Spree::Money.new(var_in_current_currency, { currency: current_cur })
  end

  alias display_total money
  alias display_amount money

end
