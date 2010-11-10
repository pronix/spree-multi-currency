# encoding: utf-8
namespace :spree do
  namespace :extensions do
    namespace :multi_currency do
      desc "Copies public assets of the Multi Currency to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[MultiCurrencyExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(MultiCurrencyExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end

      desc "Получение валют"
      task :currency => :environment do
        require 'open-uri'
        doc = Nokogiri::XML.parse(open("http://www.cbr.ru/scripts/XML_daily.asp?date_req=#{Time.now.strftime('%d/%m/%Y')}"))
        date = Date.parse doc.xpath("//ValCurs").attr("Date").to_s
        doc.xpath("//ValCurs/Valute").each do |valute|
          char_code  = valute.xpath("./CharCode").text.to_s
          num_code   = valute.xpath("./NumCode").text.to_s

          name       =  valute.xpath("./Name").text.to_s
          value      = valute.xpath("./Value").text.gsub(',','.').to_f
          nominal    = valute.xpath("./Nominal").text
          currency = Currency.get(num_code, { :num_code => num_code, :char_code => char_code, :name => name})
          currency && CurrencyConverter.add(currency, date, value, nominal)
          # @fields[code] = {}
          # @fields[code][:value] = valute.xpath("./Value").text.gsub(',','.').to_f
          # @fields[code][:name] = valute.xpath("./Name").text
          # @fields[code][:nominal] = valute.xpath("./Nominal").text
        end
      end

      # <Valute ID="R01020A">
      # 	<NumCode>944</NumCode>
      # 	<CharCode>AZN</CharCode>
      # 	<Nominal>1</Nominal>
      # 	<Name>Азербайджанский манат</Name>
      # 	<Value>38,5861</Value>
      # </Valute>

    end
  end
end
