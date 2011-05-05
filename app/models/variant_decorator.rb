Variant.class_eval do
  extend MultiCurrency
  multi_currency :price
end
