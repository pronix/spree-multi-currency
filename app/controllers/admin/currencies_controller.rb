class Admin::CurrenciesController < Admin::BaseController
  resource_controller
  update.wants.html { redirect_to collection_url }
  create.wants.html { redirect_to collection_url }
  destroy.wants.html { redirect_to collection_url }
end
