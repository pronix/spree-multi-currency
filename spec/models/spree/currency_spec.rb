require 'spec_helper'

describe Spree::Currency do
  describe 'with loaded and setted default currency' do
    before :each do
      @rub = Spree::Currency.create(name: 'rubles', char_code: 'RUB',
                                    num_code: 623, locale: 'ru', basic: false)
    end

    it 'set basic' do
      @rub.basic!
      @rub.basic.should be_truthy
    end

    it 'should return locale without spliting' do
      @rub.locale = 'en,ru'
      expect(@rub.locale).to eq(%w(en ru))
      expect(@rub.locale(false)).to eq('en,ru')
    end

    it 'should write error message' do
      ex = Exception.new
      ex.set_backtrace(%w(1 2))
      mess = " [ Currency ] :#{ex.inspect} \n #{ex.backtrace.join('\n ')}"
      Rails.logger.should_receive(:error).with(mess)
      Spree::Currency.error_logger(ex)
    end

    it 'get currency by num code' do
      Spree::Currency.get(623).should == @rub
    end
  end

  describe 'error if' do
    it 'did not load and set default currency' do
#      I18n.locale = nil
      Spree::Currency.current!
      error_message = 'Require load and set default currency'
      error_message << '<br/>Locale field is factor for determine '
      error_message << 'current currency'
      expect do
        I18n.locale = :en
        Spree::Currency.current
      end.to raise_error(RuntimeError, error_message)
    end

    it 'did not set convervion rates' do
      Spree::CurrencyConverter.destroy_all
      expect(
        Spree::Currency.conversion_to_current(200_000, locale: 'no_locale')
      ).to eq(200_000)
    end

    it 'did not set exchange rates' do
      @rub = Spree::Currency.create(name: 'rubles', char_code: 'RUB',
                                    num_code: 623, locale: 'ru', basic: false)
      error_message = /Require load actual currency/
      expect do
        Spree::Currency.convert(150, 'RUB', 'GBP')
      end.to raise_error(RuntimeError, error_message)
    end

  end
end
