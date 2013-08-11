require 'spec_helper'

describe Spree::CurrencyController do

  it 'attempt to set incorrect currency' do
    controller.stub spree_current_user: mock_model(Spree.user_class,
                                                   has_spree_role?: true,
                                                   last_incomplete_spree_order: nil,
                                                   spree_api_key: 'fake')
    spree_get 'set', id: 'RUBLI'
    response.status.should == 302
    flash[:error].should == I18n.t(:currency_not_found)
  end

end

