# encoding: utf-8

Spree::Product.class_eval do

  # Can't use add_search_scope for this as it needs a default argument
  def self.available(available_on = nil, currency = nil)
    scope = joins(:master => :prices).where("#{Spree::Product.quoted_table_name}.available_on <= ?", available_on || Time.now)
    unless Spree::Config.show_products_without_price
      # should render product with any not null price
      scope = scope.where('spree_prices.amount IS NOT NULL')
    end
    Rails.logger.info scope.to_yaml
    scope
  end

  # FIXME may be not require remove it from array
  search_scopes.delete(:available)
  search_scopes << :available
end

Spree::Core::Search::Base.class_eval do
    def retrieve_products
      @products_scope = get_base_scope
      curr_page = page || 1

      @products = @products_scope.includes([:master => :prices])
      unless Spree::Config.show_products_without_price
        @products = @products.where("spree_prices.amount IS NOT NULL")
      end
      @products = @products.page(curr_page).per(per_page)
    end

end

