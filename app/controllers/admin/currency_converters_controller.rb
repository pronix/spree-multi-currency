class Admin::CurrencyConvertersController < Admin::BaseController
  resource_controller
  update.wants.html { redirect_to collection_url }
  create.wants.html { redirect_to collection_url }
  destroy.wants.html { redirect_to collection_url }
  private
  def collection
    @collection = CurrencyConverter.paginate(:page => params[:page], :per_page => 15)
  end
end
