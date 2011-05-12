# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'multi_currencies'
  s.version     = '1.0.3'
  s.summary     = 'Add gem summary here'
  s.required_ruby_version = '>= 1.8.7'
  s.authors     = ["Pronix LLC"]
  s.email       = ["parallel588@gmail.com","root@tradefast.ru"]
  s.homepage    = ""
  s.summary     = %q{spree-multi-currency}
  s.description = %q{spree-multi-currency}

  s.rubyforge_project = "spree-multi-currency"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_path = ['lib']


  s.add_dependency('spree_core', '>= 0.50.0')
  s.add_dependency('nokogiri',   '>= 1.4.4')
  s.add_dependency('money',      '>= 3.6.1')
  s.add_dependency('json',       '>= 1.5.1')
  s.add_development_dependency("rspec", ">= 2.5.0")
end
