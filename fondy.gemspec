# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fondy/version'

Gem::Specification.new do |spec|
  spec.name          = 'fondy'
  spec.version       = Fondy::VERSION
  spec.authors       = ['Roman Khrebtov']
  spec.email         = ['r.hrebtov@busfor.com']

  spec.summary       = 'Ruby wrapper for Fondy API'
  spec.description   = 'Ruby wrapper for Fondy API'
  spec.homepage      = 'https://github.com/busfor/fondy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rubocop'
end
