class CurrencyConverter < ActiveRecord::Base
  belongs_to :currency
  default_scope :order =>  "currency_converters.date_req ASC"
  self.per_page = 15
  class << self
    def add(currency, date, value, nominal)
      create({ :nominal => nominal, :value => value, :date_req => date, :currency => currency})
    end
  end
end
