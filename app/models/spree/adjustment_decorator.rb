# encoding: utf-8

Spree::Adjustment.class_eval do
  extend Spree::MultiCurrency
  multi_currency :amount
end
