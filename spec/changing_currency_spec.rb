require 'spec_helper'

describe 'Currencies changing' do

  it 'changes price when changing locale' do
    rub = Spree::Currency.create(name: 'rubles', char_code: 'RUB',
                                 num_code: 623, locale: 'ru', basic: false)
    usd = Spree::Currency.create(name: 'dollars', char_code: 'USD',
                                 num_code: 624, locale: 'en', basic: true)
    Spree::CurrencyConverter.create(nominal: 32, value: 1.0,
                                    currency: rub, date_req: Time.now)
    product = FactoryGirl.create(:product, :cost_price => 1)
    variant = product.master
    I18n.locale = 'en'
    variant.cost_price.should eql 1.0
    I18n.locale = 'ru'
    Spree::Currency.current!
    Spree::Currency.current.should eql rub
    variant.cost_price.to_f.should eql 32.0
  end
end
