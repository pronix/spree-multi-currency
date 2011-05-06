FEATURES_PATH = File.expand_path('../..', __FILE__)
# require define path to spree project
ENV['SPREE_GEM_PATH'] = "/home/dima/project/spree"
# or define spree as gem in Gemfile
# and decomment this
# gemfile = Pathname.new("Gemfile").expand_path
# lockfile = gemfile.dirname.join('Gemfile.lock')
# definition = Bundler::Definition.build(gemfile, lockfile, nil)
# sc=definition.index.search "spree"
# ENV['SPREE_GEM_PATH'] = sc[0].loaded_from.gsub(/\/[a-z_]*.gemspec$/,'')


# load shared env with features
require File.expand_path("#{ENV['SPREE_GEM_PATH']}/features/support/env", __FILE__)
Capybara.default_driver = :selenium
