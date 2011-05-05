Adjustment.class_eval do
  extend MultiCurrency
  multi_currency :amount
end
