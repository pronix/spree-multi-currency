# encoding: utf-8

module Spree
  class CurrencyController < Spree::BaseController

    def set
      char_code = params[:id].to_s.upcase
      @currency = Spree::Currency.find_by_char_code(char_code)
      if @currency
        session[:currency_id] = char_code.to_sym
        Spree::Currency.current!(@currency)
        flash.notice = t(:currency_changed)
      else
        flash[:error] = t(:currency_not_found)
      end

      redirect_back_or_default(root_path)
    end

  end
end
