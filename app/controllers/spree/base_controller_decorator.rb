Spree::BaseController.class_eval do
  before_filter :set_currency

  private

  def set_currency
    if session[:currency_id].present? && (@currency = Currency.find_by_char_code(session[:currency_id]))
      Currency.current!(@currency)
    end
  end

end
