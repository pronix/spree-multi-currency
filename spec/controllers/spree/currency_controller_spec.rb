require 'spec_helper'

describe Spree::CurrencyController do
  describe 'Test set currency' do
    it 'attempt to set incorrect currency' do
      allow(ApplicationController).to receive(:spree_current_user).and_return( mock_model(Spree.user_class,
                                                     has_spree_role?: true,
                                                     last_incomplete_spree_order: nil,
                                                     spree_api_key: 'fake'))
      spree_get 'set', id: 'RUBLI'
      response.status.should == 302
      flash[:error].should == I18n.t(:currency_not_found)
    end
  end

end

