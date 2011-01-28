module MultiCurrency
  def multi_currency(*args)
    [args].flatten.compact.each do |number_field|

      define_method(number_field.to_sym) do
        Currency.conversion_to_current(read_attribute(number_field.to_sym))
      end

      define_method(:"#{number_field}=") do |value|
        write_attribute(:price, Currency.conversion_from_current(value))
      end

    end

  end
end

