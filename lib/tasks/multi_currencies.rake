# add custom rake tasks here
namespace :multi_currencies do

  desc "Получение валют Сбербанк РФ"
  task :currency_sb => :environment do
    rub  = Currency.get("643", { :num_code => "643", :char_code => "RUB", :name => "Российский рубль", :basic => true})
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


  desc "Rates from European Central Bank"
  task :currency_ecb => :environment do
    require 'open-uri'
    list_iso4217 = "http://www.iso.org/iso/support/faqs/faqs_widely_used_standards/widely_used_standards_other/currency_codes/currency_codes_list-1.htm"
    doc_iso4217 = Nokogiri::HTML.parse(open(list_iso4217))
    iso4217 = { }
    doc_iso4217.css("table tr")[1..-1].map{|x|
      number_code, char_code, name = x.css("td")[-1].text.strip, x.css("td")[-2].text.strip, x.css("td")[-3].text.strip;
      iso4217[char_code] = { :char_code => char_code, :name => name, :number_code => number_code}
    }

    euro  = Currency.get("978", { :num_code => "978", :char_code => "EUR", :name => "Euro", :basic => true})

    doc = Nokogiri::XML.parse(open('http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml'))
    date = Date.strptime(doc.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube').attr("time").to_s, "%Y-%m-%d")
    doc.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube//xmlns:Cube').each do |exchange_rate|
      char_code  = exchange_rate.attribute("currency").value
      num_code   = (iso4217[char_code] && iso4217[char_code][:number_code]) || exchange_rate.attribute("currency").value
      name       = (iso4217[char_code] && iso4217[char_code][:name]) ||exchange_rate.attribute("currency").value
      value      = exchange_rate.attribute("rate").value.to_f
      nominal    = 1
      currency = Currency.get(num_code, { :num_code => num_code, :char_code => char_code, :name => name})
      currency && CurrencyConverter.add(currency, date, value, nominal)

    end
  end


end

