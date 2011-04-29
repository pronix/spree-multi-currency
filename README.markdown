= Multi Currency

Support different currency and recalculate price from one to another
===========================================
Installation
---------
Add to Gemfile
    gem "multi_currencies", :git => "git://github.com/pronix/spree-multi-currency.git"

Run
---
    rake multi_currencies:install:migrations
    rake db:migrate

Load currencies:
---------------
    rake multi_currencies:currency:iso4217         # Load currency ISO4217 http://en.wikipedia.org/wiki/ISO_4217
    rake multi_currencies:currency:okv             # Общероссийский классификатор валют...

Load rates:
----------
    rake multi_currencies:rates:cbr                               # Курс Сбербанка РФ http://www.cbr.ru
    rake "multi_currencies:rates:ecb[load_currencies]"              # Rates from European Central Bank 
  for example     rake multi_currencies:rates:google[USD]
    rake "multi_currencies:rates:google[currency,load_currencies]"  # Rates from Google


Settings
---------
        In admin block, configuration menu add two tables currency and currency conversion rate
        In reference currency enters the list of currencies, indicate if one of the major currencies (in the currency keeps all prices). Each currency assign corresponding locale.
        In Exchange Rates, provides information on the price of the currency on a specified date to the basic currency(from russian central bank).
        In the exchange rates set date, currency, and face value of the currency in the base currency.
        To fill in the exchange rate, you can use task for download exchange rates from the site of the Central Bank (http://www.cbr.ru):
        rake multi_currencies:rates:cbr, as in this problem, loading the list of currencies.

        В справочнике Валюты заносим список валют, указываем одну из валют основной (в этой валюте хранятся все цены). Каждой валюте назначаем соответствующую локаль.
        В справчнике Курсы валют, содержиться информация о цене валюты на определенную дату к основной валюте.
        В курсе валют указываеться дата, валюта, номинал и стоимость валюты в основной валюте.
        Для заполнения курса валют, можно воспользоватьбся задачей загрузки курса валют с сайта ЦБ(http://www.cbr.ru):
        rake multi_currencies:rates:cbr, так же в этой задаче идет загрузка списка валют.

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




