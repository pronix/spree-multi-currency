# encoding: utf-8

module SpreeMultiCurrency
  module Generators
    class InstallGenerator < Rails::Generators::Base

      # def add_javascripts
      #   append_file "app/assets/javascripts/store/all.js", "//= require store/spree_multi_lingual\n"
      #   append_file "app/assets/javascripts/admin/all.js", "//= require admin/spree_multi_lingual\n"
      # end
      #
      # def add_stylesheets
      #   inject_into_file "app/assets/stylesheets/store/all.css", " *= require store/spree_multi_lingual\n", :before => /\*\//, :verbose => true
      #   inject_into_file "app/assets/stylesheets/admin/all.css", " *= require admin/spree_multi_lingual\n", :before => /\*\//, :verbose => true
      # end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_multi_currency'
      end

      def run_migrations
        run 'bundle exec rake db:migrate'
      end
    end
  end
end
