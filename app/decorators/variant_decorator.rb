Variant.class_eval do

  def price
    Currency.conversion_to_current(read_attribute(:price))
  end

  def price=(value)
    conversion_value = Currency.conversion_from_current(value)
    write_attribute(:price, conversion_value)
  end

end
