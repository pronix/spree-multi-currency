module SpreeMultiCurrency
  # mattr_reader :languages
  # @@languages = [:en]
  #
  # def self.languages=(locales=[])
  #   I18n.available_locales = locales
  #   @@languages = locales
  # end

  class Engine < Rails::Engine
    engine_name 'spree_multi_currency'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # after rails config/initializers loading, setup spree_multi_lingual's language by getting
    # I18n.available_locales but it returns only [:en]
    # initializer "spree_multi_lingual.environment", :after => :load_config_initializers do |app|
    #   SpreeMultiLingual.languages = I18n.available_locales
    # end

    config.to_prepare &method(:activate).to_proc
  end
end
