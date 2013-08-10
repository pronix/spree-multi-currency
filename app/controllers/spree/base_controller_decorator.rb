# encoding: utf-8

Spree::BaseController.class_eval do
  before_filter :set_currency

  private

  def set_currency
    if session[:currency_id].present?
        @currency = Spree::Currency.find_by_char_code(session[:currency_id])
        Spree::Currency.current!(@currency) if @currency
    end
  end

end
