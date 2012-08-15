require 'spec_helper'

describe "Currencies changing" do

  it "changes price when changing locale"
    rub = Spree::Currency.create(:char_code => "RUB", :locale => "ru", :basic => false)
    usd = Spree::Currency.create(:char_code => "USD", :locale => "en", :basic => true)
    rub.currency_coverters << Spree::CurrencyConverter.create(:nominal => 32, :value => 1.0)
    product = FactoryGirl.create(:product, :price => 1)
    I18n.current_locale = "en"
    product.price.should eql 1
    I18n.current_locale = "ru"
    product.price.should eql 32
  end  
end