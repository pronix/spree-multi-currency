require 'spec_helper'

describe Spree::Variant do
  before :each do
    Spree::Config.currency = 'USD'
    @rub = Spree::Currency.create(name: 'rubles', char_code: 'RUB',
                                  num_code: 623, locale: 'ru', basic: false)
    @eur = Spree::Currency.create(name: 'euro', char_code: 'EUR',
                                  num_code: 678, locale: 'de', basic: false)
    @usd = Spree::Currency.create(name: 'dollars', char_code: 'USD',
                                  num_code: 624, locale: 'en', basic: true)

    Spree::CurrencyConverter.create!(nominal: 1.0, value: 1 / 32.0,
                                     currency: @rub, date_req: Time.now)

    Spree::CurrencyConverter.create!(nominal: 1.0, value: 1 / 0.75,
                                     currency: @eur, date_req: Time.now)

    @product = create(:base_product, name: 'product1')
    @product.save!
    @variant = @product.master
    @variant.prices.destroy_all
    @variant.prices.create!(currency: @rub.char_code,
                            amount: 100)
  end

  it 'check variant without basic_price and current_price' do
    Spree::Currency.current!(@eur)
    expect(@variant.get_price).to eq(((100 / 32.0) * 0.75).round(2))
    Spree::Currency.current!(@usd)
    expect(@variant.get_price).to eq((100 / 32.0).round(2))
  end

  it 'set price for existing product' do
    @variant.price = 2000
    expect(@variant.price).to eq(2000)
  end

  it 'set price for existing product with current base currency' do
    @variant.prices.create!(currency: @usd.char_code,
                            amount: 100)
    @variant.price = 2000
    expect(@variant.price).to eq(2000)
  end
end
