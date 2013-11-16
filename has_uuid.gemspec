# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_uuid/version'

Gem::Specification.new do |spec|
  spec.name          = "has_uuid"
  spec.version       = HasUuid::VERSION
  spec.authors       = ["Jason Harrelson"]
  spec.email         = ["cjharrelson@iberon.com"]
  spec.description   = %q{Provides facilities to utilize UUIDs with ActiveRecord, including model and migration extensions.}
  spec.summary       = %q{Provides facilities to utilize UUIDs with ActiveRecord.}
  spec.homepage      = "https://github.com/midas/has_uuid"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  #spec.add_development_dependency "database_cleaner"
  #spec.add_development_dependency "forgery"
  #spec.add_development_dependency "fabrication"
  #spec.add_development_dependency "sqlite3"
  #spec.add_development_dependency "pg"
  #spec.add_development_dependency "mysql2"

  #spec.add_runtime_dependency "uuidtools"
  spec.add_runtime_dependency "activerecord", '>= 3.1'
  spec.add_runtime_dependency "activesupport", '>= 3.1'
end
