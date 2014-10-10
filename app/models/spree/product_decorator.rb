# encoding: utf-8

Spree::Product.class_eval do

   

  # Can't use add_search_scope for this as it needs a default argument
  def self.available(available_on = nil, currency = nil)
    scope = joins(:master => :prices).where("#{Spree::Product.quoted_table_name}.available_on <= ?", available_on || Time.now)
    unless Spree::Config.show_products_without_price
      # should render product with any not null price
      scope = scope.where('spree_prices.amount IS NOT NULL')
    end
    scope
  end

  # FIXME may be not require remove it from array
  search_scopes.delete(:available)
  search_scopes << :available
end

