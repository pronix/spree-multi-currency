Spree::LineItem.class_eval do
  extend Spree::MultiCurrency
  multi_currency :price

  def raw_amount
    read_attribute(:price) * self.quantity
  end

end
