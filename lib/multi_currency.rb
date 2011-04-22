module MultiCurrency
  def multi_currency(*args)
    options = args.extract_options!
    [args].flatten.compact.each do |number_field|

      define_method(number_field.to_sym) do
        if options.has_key?(:rate_at_date) && options[:rate_at_date].is_a?(Proc)
          Currency.conversion_to_current(read_attribute(number_field.to_sym),
                                         { :date => options[:rate_at_date].call(self) })
        else
          Currency.conversion_to_current(read_attribute(number_field.to_sym))
        end
      end

      define_method(:"#{number_field}=") do |value|
        write_attribute(number_field.to_sym, Currency.conversion_from_current(value))
      end

    end

  end
end

