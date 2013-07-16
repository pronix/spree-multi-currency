# encoding: utf-8

require 'spec_helper'

feature 'Buy' do
  background :each do
    # factories defined in spree/core/lib/spree/testing_support/factories
    # @calculator = create(:calculator)
    zone = create(:zone, name: 'CountryZone')
    @ship_cat = create(:shipping_category,name: 'all')

    @product = create(:base_product, name: 'product1')
    @product.shipping_category = @ship_cat
    @product.save!
    @product.prices.each {|x| puts x.to_yaml }
    stock = @product.stock_items.first
    stock.adjust_count_on_hand(100)
    stock.save!

    @country = create(:country,
                      iso_name: 'SWEDEN',
                      name: 'Sweden',
                      iso: 'SE',
                      iso3: 'SE',
                      numcode: 46 )
    @country.states_required = false
    @country.save!
    @state = @country.states.create(name: 'Stockholm')
    zone.members.create(zoneable: @country,zoneable_type: 'Country')

    ship_meth=FactoryGirl.create(:shipping_method,
        :calculator_type => 'Spree::Calculator::Shipping::FlatRate',
        :display_on => 'both')
    ship_meth.zones << zone
    ship_meth.shipping_categories << @ship_cat
    ship_meth.calculator.preferred_amount = 90
    ship_meth.save!

    # defined in spec/factories/klarna_payment_factory
    @pay_method = create(:payment_method)
  end

  scenario 'visit root page' do
    name = @product.name
    visit '/'
    save_and_open_page
    expect(page).to have_content(name)
    click_link name
    click_button 'add-to-cart-button'
    click_button 'checkout-link'
    fill_in 'order_email', with: 'test2@example.com'
    click_button 'Continue'

    # fill addresses
    # copy from spree/backend/spec/requests/admin/orders/order_details_spec.rb
    # may will in future require update
    check 'order_use_billing'
    fill_in 'order_bill_address_attributes_firstname', :with => 'Joe'
    fill_in 'order_bill_address_attributes_lastname', :with => 'User'
    fill_in 'order_bill_address_attributes_address1', :with => '7735 Old Georgetown Road'
    fill_in 'order_bill_address_attributes_address2', :with => 'Suite 510'
    fill_in 'order_bill_address_attributes_city', :with => 'Bethesda'
    fill_in 'order_bill_address_attributes_zipcode', :with => '20814'
    fill_in 'order_bill_address_attributes_phone', :with => '301-444-5002'
    within('fieldset#billing') do
      select @country.name , from: 'Country'
#      select @state.name, from: 'State'
    end

    click_button 'Save and Continue'

    # shipping
    click_button 'Save and Continue'

    # payment page
    fill_in 'social_security_number', with: '410321-9202'
    click_button 'Save and Continue'

    # confirm
    # FIXME undefined method `authorize' for #<Spree::PaymentMethod::KlarnaInvoice:0x0000000d4c8ee0>
    # click_button 'Place Order'
    #

    # as result require receive invoice and check that invoice created in klarna
    # save_and_open_page
  end
end
