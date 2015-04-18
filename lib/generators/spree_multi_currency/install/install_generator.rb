# encoding: utf-8
module SpreeMultiCurrency
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: true

      def add_javascripts
       frontend_js_file = "app/assets/stylesheets/spree/frontend.js"
        
        if  File.exist?(frontend_js_file)
          append_file frontend_js_file, "//= require spree/frontend/spree_multi_currency\n"
        end
       
      end
      
      def add_stylesheets
        frontend_css_file = "app/assets/stylesheets/spree/frontend.css"
        
        if  File.exist?(frontend_css_file)
          inject_into_file frontend_css_file, " *= require spree/frontend/spree_multi_currency\n", :before => /\*\//, :verbose => true
          
        end
      end


      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_multi_currency'
      end

      def run_migrations
        message = 'Would you like to run the migrations now? [Y/n]'
        run_migrations = options[:auto_run_migrations] ||
          ['', 'y', 'Y'].include?(ask message)
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
