# encoding: utf-8

require 'spec_helper'

describe 'Currencies changing' do
    before :each do
        Spree::Product.destroy_all
        Spree::Currency.destroy_all
        Spree::CurrencyConverter.destroy_all

        @rub = Spree::Currency.create(name: 'rubles', char_code: 'RUB',
                                 num_code: 623, locale: 'ru', basic: false)
        @usd = Spree::Currency.create(name: 'dollars', char_code: 'USD',
                                 num_code: 624, locale: 'en', basic: true)
        Spree::CurrencyConverter.add(@rub, Time.now, 1.0, 32.0)
    end

    it 'changes price when changing locale' do
      product = FactoryGirl.create(:product, :cost_price => 1)
      variant = product.master
      I18n.locale = 'en'
      variant.cost_price.should eql 1.0
      I18n.locale = 'ru'
      Spree::Currency.current!
      Spree::Currency.current.should eql @rub
      variant.cost_price.to_f.should eql 32.0

    end

    it 'check save master_price' do
      I18n.locale = 'en'
      Spree::Currency.current!
      product = Spree::Product.new(name: 'test123', price: 123.54)
      product.save!
      product.reload
      product.price.should eql 123.54
      product.master.price.should eql 123.54
      I18n.locale = 'ru'
      Spree::Currency.current!
      product.price.should eql 3953.28
      product.master.price.should eql 3953.28
    end
end
