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

    task :okv => :environment do
      url = 'http://ru.wikipedia.org/wiki/%D0%9E%D0%B1%D1%89%D0%B5%D1%80%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%B8%D0%B9_%D0%BA%D0%BB%D0%B0%D1%81%D1%81%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%82%D0%BE%D1%80_%D0%B2%D0%B0%D0%BB%D1%8E%D1%82'
      data = Nokogiri::HTML.parse(open(url))
      keys = [:char_code, :num_code, :discharge, :name, :countries ]
      data.css('table:first tr')[1..-1].map{ |d|
        Hash[*keys.zip(d.css('td').map { |x| x.text.strip }).flatten]
      }.each do |n|
        Spree::Currency.find_by_num_code(n[:num_code]) ||
          Spree::Currency.create(n.except(:discharge).except(:countries))
      end

    end

    desc 'Load currency ISO4217 http://en.wikipedia.org/wiki/ISO_4217'
    task :iso4217 => :environment do
      url = 'http://en.wikipedia.org/wiki/ISO_4217'
      data = Nokogiri::HTML.parse(open(url))
      keys = [:char_code, :num_code, :discharge, :name, :countries ]
      data.css('table:eq(1) tr')[1..-1].map{|d|
        Hash[*keys.zip(d.css('td').map {|x| x.text.strip }).flatten]
      }.each do  |n|
        Spree::Currency.find_by_num_code(n[:num_code]) ||
          Spree::Currency.create(n.except(:discharge).except(:countries))
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

    desc 'Rates from Google'
    task :google, [:currency, :load_currencies] => :environment do |t, args|
      Rake::Task['spree_multi_currency:currency:iso4217'].invoke if args.load_currencies
      if args.currency
        default_currency = Spree::Currency.where('char_code = :currency_code or num_code = :currency_code', currency_code: args.currency.upcase ).first
      else
        default_currency = Spree::Currency.get('978', eur_hash)
      end
      default_currency.basic!
      date = Time.now
      puts "Loads currency data from Google using #{default_currency}"
      Spree::Currency.all.each do |currency|
        unless currency == default_currency
          url = "http://www.google.com/ig/calculator?hl=en&q=1#{ currency.char_code }%3D%3F#{ default_currency.char_code }"
          puts url
          @data = JSON.parse(open(url).read.gsub(/lhs:|rhs:|error:|icc:/){ |x| "\"#{x[0..-2]}\":" })
          if @data['error'].blank?
            @value = BigDecimal(@data['rhs'].split(' ')[0])
            Spree::CurrencyConverter.add(currency, date, @value, 1)
          end
        end
      end
    end
  end

end

