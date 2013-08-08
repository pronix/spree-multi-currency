# encoding: utf-8

Spree::LineItem.class_eval do
  extend Spree::MultiCurrency
  multi_currency :price

  def copy_price
    if variant && price.nil?
      self.price = variant.read_attribute(:price)
    end
  end

  def raw_amount
    read_attribute(:price) * self.quantity
  end

end
