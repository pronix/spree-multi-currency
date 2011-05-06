require 'bundler'
Bundler::GemHelper.install_tasks

# copy from core
require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'

# require define path to spree project
ENV['SPREE_GEM_PATH'] = "/home/dima/project/spree"
# or define spree as gem in Gemfile
# and decomment this
# gemfile = Pathname.new("Gemfile").expand_path
# lockfile = gemfile.dirname.join('Gemfile.lock')
# definition = Bundler::Definition.build(gemfile, lockfile, nil)
# sc=definition.index.search "spree"
# ENV['SPREE_GEM_PATH'] = sc[0].loaded_from.gsub(/\/[a-z_]*.gemspec$/,'')

spec = eval(File.read('multi_currencies.gemspec'))
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc "Release to gemcutter"
task :release => :package do
  require 'rake/gemcutter'
  Rake::Gemcutter::Tasks.new(spec).define
  Rake::Task['gem:push'].invoke
end

desc "Default Task"
task :default => [:spec, :cucumber ]

desc "Regenerates a rails 3 app for testing"
task :test_app do
  require "#{ENV['SPREE_GEM_PATH']}/lib/generators/spree/test_app_generator"
  class CoreTestAppGenerator < Spree::Generators::TestAppGenerator

    def install_spree_core
      inside "test_app" do
        run 'rake spree_core:install'
        run 'rake spree_auth:install'
        run 'rake multi_currencies:install'
        run "rake spree_sample:install"
        run "sed -i 's/development/cucumber/' ../db/sample/payment_methods.yml"
        run 'rake db:seed'
      end
    end

    def migrate_db
      run_migrations
    end

    protected
    def full_path_for_local_gems
      <<-gems
gem 'multi_currencies', :path => \'#{File.dirname(__FILE__)}\'
gem 'spree_core', :path => \'#{ENV['SPREE_GEM_PATH']}/core\'
gem 'spree_sample', :path => \'#{ENV['SPREE_GEM_PATH']}/sample\'
gem 'spree_auth', :path => \'#{ENV['SPREE_GEM_PATH']}/auth\'
      gems
    end
  end
  CoreTestAppGenerator.start
end

require File.expand_path("./core/lib/tasks/common", ENV['SPREE_GEM_PATH'])

