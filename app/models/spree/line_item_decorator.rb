# encoding: utf-8

Spree::LineItem.class_eval do
  extend Spree::MultiCurrency
  multi_currency :price

  def copy_price
    self.price = variant.reade_attribute(:price) if variant && price.nil?
  end

  def raw_amount
    read_attribute(:price) * self.quantity
  end

end
