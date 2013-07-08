$:.push File.expand_path("../lib", __FILE__)
require 'puppet-graph/version'

Gem::Specification.new do |s|
  s.name = 'puppet-graph'
  s.version = PuppetGraph::VERSION
  s.homepage = 'https://github.com/rodjek/puppet-graph/'
  s.summary = ''
  s.description = ''
  s.required_ruby_version = '>= 1.8.7'

  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(/^bin\//).map { |f| File.basename(f) }
  s.test_files = s.files.grep(/^(test|spec|features)\//)
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rcov'

  s.authors = ['Tim Sharpe']
  s.email = 'tim@sharpe.id.au'
end
