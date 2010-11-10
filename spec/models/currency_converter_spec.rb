require File.dirname(__FILE__) + '/../spec_helper'

describe CurrencyConverter do
  before(:each) do
    @currency_converter = CurrencyConverter.new
  end

  it "should be valid" do
    @currency_converter.should be_valid
  end
end
