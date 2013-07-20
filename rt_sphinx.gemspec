# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'rt_sphinx'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Dmitry Koprov']
  s.email       = ['dmitry.koprov@gmail.com']
  s.homepage    = 'http://dkoprov.github.com/rt_sphinx/'
  s.summary     = %q{A tool to work with Sphinx search real time indexes}
  s.description = %q{A tool for populating Sphinx search service through real time indexes.}

  s.rubyforge_project = 'rt_sphinx'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake',   '>= 0.9.2'
  s.add_development_dependency 'rspec',  '>= 2.5.0'
  s.add_development_dependency 'yard',   '>= 0.7.2'
end
