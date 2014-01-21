# encoding: utf-8

Spree::Variant.class_eval do
  extend Spree::MultiCurrency
  multi_currency :cost_price

  # if save variant - require save prices
  after_save :save_price


  # get spree_price for current currency or
  # basic or
  # any other
  def get_price
    char_code = current_char_code
    current_price = prices.where(currency: char_code).first
    if current_price && current_price.amount.present?
      amount = current_price.amount
      return amount
    else
      basic_char = Spree::Currency.basic.try(:char_code)
      basic_price = prices.where(currency: basic_char).first
      if basic_price
        amount = basic_price.amount
        return Spree::Currency.conversion_to_current(amount)
      else
        spree_price = prices.first
        amount = spree_price.amount
        res = Spree::Currency.convert(amount, spree_price.currency, char_code)
        return res
      end
    end
  end

  # FIXME - may be will used in other classes
  def current_char_code
    Spree::Currency.current.try(:char_code) || Spree::Config[:currency]
  end

  # prices stored in spree_prices
  def price
    attr = @price
    if attr.nil? && !new_record?
      get_price
    else
      attr
    end
  end

  # assign price
  # if new record - save to attribute
  # if saved - create price
  def price=(value)
    @price = value
    unless new_record?
      cur = current_char_code
      base_price = prices.where(currency: cur).first
      if base_price
        base_price.amount = value
      else
        prices.new(amount: value, currency: cur)
      end
    end
  end


  # redefine spree method from spree/core/app/models/spree/variant.rb
  def price_in(currency)
    if currency.is_a?(String)
      char_code = currency
    else
      char_code = currency.char_code
    end
    res = prices.where(currency: char_code).first
    if res.blank? || res.amount.nil? || res.amount.to_i == 0
      res = Spree::Price.new(variant_id: id,
                             currency: currency,
                             amount: get_price)
    end
    res
  end

  private

  def save_price
    char_code = current_char_code
    spree_price = prices.where(currency: char_code).first
    spree_price = prices.new(currency: char_code) if spree_price.blank?
    spree_price.amount = @price
    if spree_price &&
       (spree_price.changed? ||
        spree_price.new_record? ||
        spree_price.amount.present?)
      spree_price.save!
    end
  end
end
