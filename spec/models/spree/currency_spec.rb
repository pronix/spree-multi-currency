require 'spec_helper'

describe Spree::Currency do
  before :each do
    @rub = Spree::Currency.create(name: 'rubles', char_code: 'RUB',
                                 num_code: 623, locale: 'ru', basic: false)
  end

  it 'set basic' do
    @rub.basic!
    @rub.basic.should be_true
  end

  it 'should return locale without spliting' do
    @rub.locale = 'en,ru'
    @rub.locale.should == ['en','ru']
    @rub.locale(false).should == 'en,ru'
  end

  it 'should write error message' do
    ex = Exception.new
    ex.set_backtrace(['1','2'])
    mess = " [ Currency ] :#{ex.inspect} \n #{ex.backtrace.join('\n ')}"
    Rails.logger.should_receive(:error).with(mess)
    Spree::Currency.error_logger(ex)
  end

  it 'get currency by num code' do
    Spree::Currency.get(623).should == @rub
  end

end
