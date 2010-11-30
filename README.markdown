= Multi Currency

Support different currency and recalculate price from one to another
===========================================
Installation
---------
Add to Gemfile
    gem "multi_currencies", :git => "git://github.com/pronix/spree-multi-currency.git"

Run
    rake multi_currencies:install:migrations

Settings
---------
        In admin block, configuration menu add two tables currency and currency conversion rate
        In reference currency enters the list of currencies, indicate if one of the major currencies (in the currency keeps all prices). Each currency assign corresponding locale.
        In Exchange Rates, provides information on the price of the currency on a specified date to the basic currency(from russian central bank).
        In the exchange rates set date, currency, and face value of the currency in the base currency.
        To fill in the exchange rate, you can use task for download exchange rates from the site of the Central Bank (http://www.cbr.ru):
        rake spree: extensions: multi_currency: currency_rb, as in this problem, loading the list of currencies.

        В справочнике Валюты заносим список валют, указываем одну из валют основной (в этой валюте хранятся все цены). Каждой валюте назначаем соответствующую локаль.
        В справчнике Курсы валют, содержиться информация о цене валюты на определенную дату к основной валюте.
        В курсе валют указываеться дата, валюта, номинал и стоимость валюты в основной валюте.
        Для заполнения курса валют, можно воспользоватьбся задачей загрузки курса валют с сайта ЦБ(http://www.cbr.ru):
        rake spree:extensions:multi_currency:currency_rb, так же в этой задаче идет загрузка списка валют.
