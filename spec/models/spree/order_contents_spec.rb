require 'spec_helper'

describe Spree::OrderContents do
  before :each do
    # factories defined in spree/core/lib/spree/testing_support/factories
    Spree::Config.currency = 'USD'
    rub = Spree::Currency.create(name: 'rubles', char_code: 'RUB',
                                 num_code: 623, locale: 'ru', basic: false)
    usd = Spree::Currency.create(name: 'dollars', char_code: 'USD',
                                 num_code: 624, locale: 'en', basic: true)

    Spree::CurrencyConverter.create!(nominal: 1.0, value: 32.0,
                                     currency: rub, date_req: Time.now)
    Spree::Config.show_products_without_price = true

    @ship_cat = create(:shipping_category, name: 'all')

    @product = create(:base_product, name: 'product1')
    @product.save!
    stock = @product.stock_items.first
    stock.adjust_count_on_hand(100)
    stock.save!

    @country = create(:country,
                      iso_name: 'SWEDEN',
                      name: 'Sweden',
                      iso: 'SE',
                      iso3: 'SE',
                      numcode: 46)
    @country.states_required = false
    @country.save!
    @state = @country.states.create(name: 'Stockholm')

    ship_meth = FactoryGirl.create(:shipping_method,
                                   calculator_type:
                                       'Spree::Calculator::Shipping::FlatRate',
                                   display_on: 'both')
    ship_meth.calculator.preferred_amount = 90
    ship_meth.save!
    zone = Spree::Zone.first
    zone.members.create!(zoneable: @country, zoneable_type: 'Spree::Country')
    ship_meth.zones << zone

    # defined in spec/factories/klarna_payment_factory
    @pay_method = create(:payment_method)
  end

  it 'add variant to order with existing line item' do
    var = create :variant
    line_item = create :line_item, variant: var
    order = create :order_with_line_items
    result_line_item = order.contents.add_to_line_item(line_item, var, 1)
    expect(result_line_item.quantity).to eq(2)
  end

  it 'add variant to order with unexisting line item' do
    var = create :variant
    order = create :order_with_line_items
    result_line_item = order.contents.add_to_line_item(nil, var, 1)
    expect(result_line_item.quantity).to eq(1)
    expect(var.price).to eq(result_line_item.price)
  end
end
