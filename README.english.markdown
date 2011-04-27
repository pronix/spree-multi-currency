# Spree Multi-Currency

Support different currency and recalculate price from one to another

Installation
---------
Add to Gemfile

    gem "multi_currencies", :git => "git://github.com/pronix/spree-multi-currency.git"

Run
---
Install the migrations for two new tables (currencies and currency conversion rates):

    rake multi_currencies:install:migrations
    rake db:migrate

Load currencies:
---------------
Load up the list of all international currencies with corresponding codes:

    rake multi_currencies:currency:iso4217         # Load currency ISO4217 table from Wikipedia http://en.wikipedia.org/wiki/ISO_4217
    rake multi_currencies:currency:okv             # Central Bank of Russian Federation

This step is not obligatory, i.e. you can manually fill up the 'currencies' table, but it's more practical to load the list with rake task above (and be sure the codes are OK), and then remove the currencies you don't want to support.

Load rates:
----------
*Warning* Rates are being calculated relative to currency configured as 'basic'. It is therefore obligatory to visit Spree admin panel (or use Rails console) and edit one of the currencies to be the 'basic' one.

Basic currency is also the one considered to be stored as product prices, shipment rates etc., from which all the other ones will be calculated using the rates.

After setting the basic currency, time to load the rates using one of the rake tasks below. There are three sources of conversion rates supported by this extension:

1. Rates from Central Bank of Russian Federation http://www.cbr.ru. These assume Russian Ruble is your basic currency:
    
        rake multi_currencies:rates:cbr 
    
2. Rates from European Central Bank. These assume Euro is your basic currency:
    
        rake multi_currencies:rates:ecb
    
3. Rates from Google.
    
        rake multi_currencies:rates:google[currency]
    
The argument in square brackets is the iso code of your basic currency, so to load rates when US Dollar is your basic currency, use
    
        rake multi_currencies:rates:google[usd]
    
There's also an optional square-bracket-enclosed parameter "load_currencies" for :rates tasks above, but it just loads up currencies table from Wikipedia, so is not needed at this point.

Settings
---------
In Spree Admin Panel, Configuration tab, two new options appear: Currency Settings and Currency Converters. 

It's best to leave Currency Converters as-is, to be populated and updated by rake multi_currencies:rates tasks.

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




