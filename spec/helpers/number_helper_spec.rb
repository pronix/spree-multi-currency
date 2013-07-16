require 'spec_helper'

describe ActionView::Helpers::NumberHelper do
  context 'number_to_currency' do
    specify do
      Spree::Currency.create!(num_code: '840', char_code: 'USD', name: 'usd', locale: 'en')
      Spree::Currency.create!(num_code: '643', char_code: 'RUB', name: 'rub', locale: 'ru')
      I18n.locale = 'en'
      Spree::Currency.current!
      number_to_currency(100.2).should == '$100.20'
      number_to_currency(-2.12).should == '-2.12 $'
      I18n.locale = 'ru'
      Spree::Currency.current!
      number_to_currency(10).should == '10.00 руб.'
      number_to_currency('11').should == '11.00 руб.'
      number_to_currency(-10.23).should == '-10.23 руб.'
    end
  end
end
