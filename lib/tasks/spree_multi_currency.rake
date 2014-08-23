# encoding: utf-8

require 'open-uri'
require 'nokogiri'
# add custom rake tasks here
namespace :spree_multi_currency do
  eur_hash = { num_code: '978', char_code: 'EUR', name: 'Euro' }

  namespace :currency do
    desc "Общероссийский классификатор валют (сокращ. ОКВ) - http://ru.wikipedia.org/wiki/Общероссийский_классификатор_валют"

    task :from_moneylib => :environment do
      ::Money::Currency.table.each do |x|
        Spree::Currency.create(char_code: x[1][:iso_code],
                               name: x[0],
                               num_code: x[1][:iso_numeric])
      end
    end
  end

  namespace :rates do
    desc 'Курс Сбербанка РФ http://www.cbr.ru'
    task :cbr => :environment do
      rub  = Spree::Currency.get('643', { num_code: '643', char_code: 'RUB', name: 'Российский рубль' })
      rub.basic!
      url = "http://www.cbr.ru/scripts/XML_daily.asp?date_req=#{Time.now.strftime('%d/%m/%Y')}"
      data = Nokogiri::XML.parse(open(url))
      date_str = data.xpath('//ValCurs').attr('Date').to_s
      date = Date.strptime(date_str, (date_str =~ /\./ ? '%d.%m.%Y' : '%d/%m/%y'))
      data.xpath('//ValCurs/Valute').each do |valute|
        char_code  = valute.xpath('./CharCode').text.to_s
        num_code   = valute.xpath('./NumCode').text.to_s
        name       = valute.xpath('./Name').text.to_s
        value      = valute.xpath('./Value').text.gsub(',', '.').to_f
        nominal    = valute.xpath('./Nominal').text
        currency   = Spree::Currency.get(num_code, { num_code: num_code,
                                                     char_code: char_code,
                                                     name: name })
        currency && Spree::CurrencyConverter.add(currency, date, value, nominal)
      end
    end

    desc 'Rates from European Central Bank'
    task :ecb, [:load_currencies] => :environment do |t, args|
      if args.load_currencies
        Rake::Task['spree_multi_currency:currency:iso4217'].invoke
      end

      euro  = Spree::Currency.get('978', eur_hash)
      euro.basic!
      url = 'http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml'
      data = Nokogiri::XML.parse(open(url))
      date = Date.strptime(data.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube').attr('time').to_s, "%Y-%m-%d")
      data.xpath('gesmes:Envelope/xmlns:Cube/xmlns:Cube//xmlns:Cube').each do |exchange_rate|
        char_code      = exchange_rate.attribute('currency').value.to_s.strip
        nominal, value = exchange_rate.attribute('rate').value.to_f, 1
        currency = Spree::Currency.find_by_char_code(char_code)
        currency && Spree::CurrencyConverter.add(currency, date, value, nominal)
      end
    end

  end

end

