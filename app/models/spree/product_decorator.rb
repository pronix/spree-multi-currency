# encoding: utf-8

Spree::Product.class_eval do

   
  after_save :save_price

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
  
  # master price isn't updated for saved records
  def save_price
    unless new_record?
      master.save_price
    end
  end
end

