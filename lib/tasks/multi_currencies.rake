require 'open-uri'
# add custom rake tasks here
namespace :multi_currencies do

  namespace :currency do
    desc "Общероссийский классификатор валют (сокращ. ОКВ) - http://ru.wikipedia.org/wiki/Общероссийский_классификатор_валют"

    task :okv => :environment do
      url = "http://ru.wikipedia.org/wiki/%D0%9E%D0%B1%D1%89%D0%B5%D1%80%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%B8%D0%B9_%D0%BA%D0%BB%D0%B0%D1%81%D1%81%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%82%D0%BE%D1%80_%D0%B2%D0%B0%D0%BB%D1%8E%D1%82"
      data = Nokogiri::HTML.parse(open(url))
      keys = [:char_code, :num_code, :discharge, :name, :countries ]
      data.css("table:first tr")[1..-1].map{ |d|
        Hash[*keys.zip(d.css("td").map {|x| x.text.strip }).flatten]
      }.each { |n|
        Currency.find_by_num_code(n[:num_code]) ||  Currency.create(n.except(:discharge).except(:countries))
      }

    end

    desc "Load currency ISO4217 http://en.wikipedia.org/wiki/ISO_4217"
    task :iso4217 => :environment do
      url = "http://en.wikipedia.org/wiki/ISO_4217"
      data = Nokogiri::HTML.parse(open(url))
      keys = [:char_code, :num_code, :discharge, :name, :countries ]
      data.css("table:eq(2) tr")[1..-1].map{|d|
        Hash[*keys.zip(d.css("td").map {|x| x.text.strip }).flatten]
      }.each { |n|
        Currency.find_by_num_code(n[:num_code]) ||  Currency.create(n.except(:discharge).except(:countries))
      }
    end

  end

  namespace :rates do
    desc "Курс Сбербанка РФ http://www.cbr.ru"
    task :cbr => :environment do
      rub  = Currency.get("643", { :num_code => "643", :char_code => "RUB", :name => "Российский рубль"})
      rub.basic!
      url = "http://www.cbr.ru/scripts/XML_daily.asp?date_req=#{Time.now.strftime('%d/%m/%Y')}"
      data = Nokogiri::XML.parse(open(url))
      date_str = data.xpath("//ValCurs").attr("Date").to_s
      date = Date.strptime(date_str, (date_str =~ /\./ ? '%d.%m.%Y' : '%d/%m/%y'))
      data.xpath("//ValCurs/Valute").each do |valute|
        char_code  = valute.xpath("./CharCode").text.to_s
        num_code   = valute.xpath("./NumCode").text.to_s
        name       = valute.xpath("./Name").text.to_s
        value      = valute.xpath("./Value").text.gsub(',','.').to_f
        nominal    = valute.xpath("./Nominal").text
        currency   = Currency.get(num_code, { :num_code => num_code, :char_code => char_code, :name => name})
        currency && CurrencyConverter.add(currency, date, value, nominal)
      end
    end

    desc "Rates from European Central Bank"
    task :ecb, [:load_currencies] => :environment do |t, args|
      Rake::Task["multi_currencies:currency:iso4217"].invoke if args.load_currencies
      euro  = Currency.get("978", { :num_code => "978", :char_code => "EUR", :name => "Euro"})
      euro.basic!
      url = 'http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml'
      data = Nokogiri::XML.parse(open(url))
      date = Date.strptime(data.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube').attr("time").to_s, "%Y-%m-%d")
      data.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube//xmlns:Cube').each do |exchange_rate|
        char_code      = exchange_rate.attribute("currency").value.to_s.strip
        value, nimonal = exchange_rate.attribute("rate").value.to_f, 1
        currency = Currency.find_by_char_code(char_code)
        currency && CurrencyConverter.add(currency, date, value, nominal)
      end

    end

    desc "Rates from Google"
    task :google, [:currency, :load_currencies] => :environment do |t, args|
      Rake::Task["multi_currencies:currency:iso4217"].invoke if args.load_currencies
      default_currency = Currency.where(" char_code = :currency_code or num_code = :currency_code",
                                        :currency_code => args.currency || 978).first ||
                         Currency.get("978", { :num_code => "978", :char_code => "EUR", :name => "Euro"})
      default_currency.basic!
      date = Time.now
      Currency.all.each { |currency|
        unless currency == default_currency
          url = "http://www.google.com/ig/calculator?hl=en&q=1#{ currency.char_code }%3D%3F#{ default_currency.char_code }"
          @data = JSON.parse(open(url).read.gsub(/lhs:|rhs:|error:|icc:/){ |x| "\"#{x[0..-2]}\":"})
          if @data["error"].blank?
            @value = BigDecimal(@data["rhs"].split(' ')[0])
            CurrencyConverter.add(currency, date, @value, 1)
          end
        end
      }
    end
  end



end

