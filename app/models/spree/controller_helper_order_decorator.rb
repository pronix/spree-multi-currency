# encoding: utf-8

Spree::Core::ControllerHelpers::Order.class_eval do

  # redefined spree/core/lib/spree/core/controller_helpers/order.rb
  def current_currency
    Spree::Currency.current.char_code
  end

end

