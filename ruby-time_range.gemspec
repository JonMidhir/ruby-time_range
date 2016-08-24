# frozen_string_literal: true
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_range/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-time_range'
  spec.version       = TimeRange::VERSION
  spec.authors       = ['Jon Hope']
  spec.email         = ['me@jhope.ie']

  spec.summary       = 'Enhance your Ruby project with time-based ranges.'
  spec.description   = 'Enhance your Ruby project with time-based ranges.'
  spec.homepage      = 'https://github.com/jonmidhir/ruby-time_range'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
end
