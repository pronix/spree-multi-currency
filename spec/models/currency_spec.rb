require File.dirname(__FILE__) + '/../spec_helper'

describe Currency do
  before(:each) do
    @currency = Currency.new
  end

  it "should be valid" do
    @currency.should be_valid
  end
end
