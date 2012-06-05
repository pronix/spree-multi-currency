Spree::Variant.class_eval do
  extend Spree::MultiCurrency
  multi_currency :price, :cost_price
end
