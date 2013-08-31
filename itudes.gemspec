$:.push File.expand_path("../lib", __FILE__)
require 'itudes/version'

Gem::Specification.new do |s|
  s.name = 'itudes'
  s.version = Geo::Itudes::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = '2013-08-25'
  s.authors = ['Alexei Matyushkin']
  s.email = 'am@mudasobwa.ru'
  s.homepage = 'http://github.com/mudasobwa/itudes'
  s.summary = %Q{Small utility library to work with [lat,lang]itudes}
  s.description = %Q{Utility library to simplify dealing with multitudes}
  s.extra_rdoc_files = [
    'LICENSE',
    'README.rdoc',
  ]

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.7')
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'yard-cucumber'
  s.add_development_dependency 'bueller'
end

