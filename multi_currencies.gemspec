Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'multi_currencies'
  s.version     = '1.0.1'
  s.summary     = 'Add gem summary here'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  # s.author            = ''
  # s.email             = ''
  # s.homepage          = ''
  # s.rubyforge_project = ''

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 0.30.0')
  s.add_dependency('nokogiri',   '>= 1.4.3.1')
  s.add_dependency('money',      '>= 3.5.4')
end
