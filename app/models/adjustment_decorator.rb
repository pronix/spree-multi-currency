Spree::Adjustment.class_eval do
  extend Spree::MultiCurrency
  multi_currency :amount
end
