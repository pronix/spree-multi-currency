# Spree Multi-Currency

Support different currency and recalculate price from one to another

Installation
---------
Add to Gemfile

    gem "spree_multi_currency", :git => "git://github.com/pronix/spree-multi-currency.git"

Run
---
Install the migrations for two new tables (currencies and currency conversion rates):

    rake spree_multi_currency:install:migrations
    rake db:migrate

Load currencies:
---------------
Load up the list of all international currencies with corresponding codes:

    rake spree_multi_currencies:currency:iso4217         # Load currency ISO4217 table from Wikipedia http://en.wikipedia.org/wiki/ISO_4217
    rake spree_multi_currencies:currency:okv             # Central Bank of Russian Federation

This step is not obligatory, i.e. you can manually fill up the 'currencies' table, but it's more practical to load the list with rake task above (and be sure the codes are OK), and then remove the currencies you don't want to support.


If you want get amount in base currency use base_total

Load rates:
----------
*Warning* Rates are being calculated relative to currency configured as 'basic'. It is therefore obligatory to visit Spree admin panel (or use Rails console) and edit one of the currencies to be the 'basic' one.

Basic currency is also the one considered to be stored as product prices, shipment rates etc., from which all the other ones will be calculated using the rates.

After setting the basic currency, time to load the rates using one of the rake tasks below. There are three sources of conversion rates supported by this extension:

1. Rates from Central Bank of Russian Federation http://www.cbr.ru. These assume Russian Ruble is your basic currency:
    
        rake spree_multi_currencies:rates:cbr 
    
2. Rates from European Central Bank. These assume Euro is your basic currency:
    
        rake spree_multi_currencies:rates:ecb
    
3. Rates from Google.
    
        rake spree_multi_currencies:rates:google[currency]
    
The argument in square brackets is the iso code of your basic currency, so to load rates when US Dollar is your basic currency, use
    
        rake spree_multi_currencies:rates:google[usd]
    
There's also an optional square-bracket-enclosed parameter "load_currencies" for :rates tasks above, but it just loads up currencies table from Wikipedia, so is not needed at this point.

Settings
---------
In Spree Admin Panel, Configuration tab, two new options appear: Currency Settings and Currency Converters. 

It's best to leave Currency Converters as-is, to be populated and updated by rake spree_multi_currencies:rates tasks.

Within Currency Settings, like mentioned above, it is essential to set one currency as the Basic one. It's also necessary to set currency's locale for every locale you want to support (again, one locale - one currency).
Feel free to go through currencies and delete the ones you don't want to support -- it will make everything easier to manage (and the :rates rake tasks will execute faster).

Changing Currency in store
--------------------------
Self-explanatory:

    http://[domain]/currency/[isocode]
    <%= link_to "eur", currency_path(:eur) %>


Translation files
--------------------
To have custom currency symbols and formatters, you need to have a corresponding entry in one of locale files, with main key like currency_XXX, where XXX is the 3-letter iso code of given currency.

If you won't have it, all the other currencies will be rendered using default formatters and symbols, which can (will) lead to confusion and inconsistency. It is recommended to create locale entries for all currencies you want to support at your store and delete all the other currencies.
 
Example for usd, eur

    --
    currency_USD: &usd
      number:
        currency:
          format:
            format: "%u%n"
            unit: "$"
            separator: "."
            delimiter: ","
            precision: 2
            significant: false
            strip_insignificant_zeros: false
    
    currency_EUR:
      <<: *usd
      number:
        currency:
          format:
            format: "%u%n"
            unit: "€"




= Multi Currency

Support different currency and recalculate price from one to another
===========================================
Installation
---------
Add to Gemfile
    gem "spree_multi_currencies", :git => "git://github.com/pronix/spree-multi-currency.git"

Run
---
    rake spree_multi_currencies:install:migrations
    rake db:migrate

Load currencies:
---------------
    rake spree_multi_currencies:currency:iso4217         # Load currency ISO4217 http://en.wikipedia.org/wiki/ISO_4217
    rake spree_multi_currencies:currency:okv             # Общероссийский классификатор валют...

Load rates:
----------
    rake spree_multi_currencies:rates:cbr                               # Курс Сбербанка РФ http://www.cbr.ru
    rake "spree_multi_currencies:rates:ecb[load_currencies]"              # Rates from European Central Bank 
  for example     rake spree_multi_currencies:rates:google[USD]
    rake "spree_multi_currencies:rates:google[currency,load_currencies]"  # Rates from Google


Settings
---------
        In admin block, configuration menu add two tables currency and currency conversion rate
        In reference currency enters the list of currencies, indicate if one of the major currencies (in the currency keeps all prices). Each currency assign corresponding locale.
        In Exchange Rates, provides information on the price of the currency on a specified date to the basic currency(from russian central bank).
        In the exchange rates set date, currency, and face value of the currency in the base currency.
        To fill in the exchange rate, you can use task for download exchange rates from the site of the Central Bank (http://www.cbr.ru):
        rake spree_multi_currencies:rates:cbr, as in this problem, loading the list of currencies.

        В справочнике Валюты заносим список валют, указываем одну из валют основной (в этой валюте хранятся все цены). Каждой валюте назначаем соответствующую локаль.
        В справчнике Курсы валют, содержиться информация о цене валюты на определенную дату к основной валюте.
        В курсе валют указываеться дата, валюта, номинал и стоимость валюты в основной валюте.
        Для заполнения курса валют, можно воспользоватьбся задачей загрузки курса валют с сайта ЦБ(http://www.cbr.ru):
        rake spree_multi_currencies:rates:cbr, так же в этой задаче идет загрузка списка валют.

Смена валюты
-------------
 По умолчанию валюта выбирается от текущей локали сайта.
 Так же можно сменить локаль по адресу http://[domain]/currency/[isocode], <%= link_to "eur", currency_path(:eur) %>

 isocode: eur, usd, rub (цифровой код прописанные в справочнике валюты)
 После смены валюты через url перестает работать смена валюты на основание текущей локали.

Формат вывода валюты
--------------------
 Формат для валюты прописан в локализации, для каждой валюты нужно описать свою локализацию (прописаны eur, usd, rub):
 Пример для usd, eur
  ---
  currency_USD: &usd
    number:
      currency:
        format:
          format: "%u%n"
          unit: "$"
          separator: "."
          delimiter: ","
          precision: 2
          significant: false
          strip_insignificant_zeros: false

  currency_EUR:
    <<: *usd
    number:
      currency:
        format:
          format: "%u%n"
          unit: "€"


For tests
_________________________

  extention require store in ./spree
  in Rakefile defined
  # require define path to spree project
  ENV['SPREE_GEM_PATH'] = "/home/dima/project/spree"
  # or define spree as gem in Gemfile
  # and decomment this
  # gemfile = Pathname.new("Gemfile").expand_path
  # lockfile = gemfile.dirname.join('Gemfile.lock')
  # definition = Bundler::Definition.build(gemfile, lockfile, nil)
  # sc=definition.index.search "spree"
  # ENV['SPREE_GEM_PATH'] = sc[0].loaded_from.gsub(/\/[a-z_]*.gemspec$/,'')


