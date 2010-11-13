# add custom rake tasks here
namespace :multi_currencies do
  desc "Получение валют Сбербанк РФ"
  task :currency_sb => :environment do
    require 'open-uri'
    doc = Nokogiri::XML.parse(open("http://www.cbr.ru/scripts/XML_daily.asp?date_req=#{Time.now.strftime('%d/%m/%Y')}"))
    date = Date.strptime(doc.xpath("//ValCurs").attr("Date").to_s, '%d/%m/%Y')
    doc.xpath("//ValCurs/Valute").each do |valute|
      char_code  = valute.xpath("./CharCode").text.to_s
      num_code   = valute.xpath("./NumCode").text.to_s

      name       =  valute.xpath("./Name").text.to_s
      value      = valute.xpath("./Value").text.gsub(',','.').to_f
      nominal    = valute.xpath("./Nominal").text
      currency = Currency.get(num_code, { :num_code => num_code, :char_code => char_code, :name => name})
      currency && CurrencyConverter.add(currency, date, value, nominal)
    end
  end

end
