require 'bundler'
Bundler::GemHelper.install_tasks

# copy from core
require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
ENV['SPREE_GEM_PATH'] = "/home/dima/project/spree"

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
  require '../lib/generators/spree/test_app_generator'
  class CoreTestAppGenerator < Spree::Generators::TestAppGenerator

    def install_spree_core
      inside "test_app" do
        run 'rake spree_core:install'
        run 'rake spree_auth:install'
        run 'rake multi_currencies:install'
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
gem 'spree_auth', :path => \'#{ENV['SPREE_GEM_PATH']}/auth\'
      gems
    end
  end
  CoreTestAppGenerator.start
end

require File.expand_path("./core/lib/tasks/common", ENV['SPREE_GEM_PATH'])

