# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_multi_currency'
  s.version     = '1.0.4'
  s.summary     = 'Add gem summary here'
  s.required_ruby_version = '>= 1.8.7'
  s.authors     = ["Pronix LLC"]
  s.email       = ["parallel588@gmail.com","pronix.service@gmail.com"]
  s.homepage    = "http://nanopodcast-pronix.rhcloud.com/"
  s.summary     = %q{spree_multi_currency}
  s.description = %q{spree_multi_currency}
  s.signing_key = '/home/dima/.gem/keys/gem-private_key.pem'
  s.cert_chain  = ['/home/dima/.gem/keys/gem-public_cert.pem']

  # s.rubyforge_project = "spree-multi-currency"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_path = ['lib']

  s.add_dependency('spree_core',		'>= 1.2.0')
  s.add_dependency('nokogiri',  		'>= 1.4.4')
  s.add_dependency('money',     		'>= 5.0.0')
  s.add_dependency('json',      		'>= 1.5.1')
  s.add_development_dependency("rspec", ">= 2.5.0")
  s.add_development_dependency 'rspec-rails'
end
