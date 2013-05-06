# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quickblox_api/version'

Gem::Specification.new do |spec|
  spec.name          = "quickblox_api"
  spec.version       = QuickbloxApi::VERSION
  spec.authors       = ["Adam Stanton"]
  spec.email         = ["adamstanton1979@gmail.com"]
  spec.description   = %q{Ruby interface to the Quickblox API}
  spec.summary       = %q{Quickblox rest interface}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "rest-client"
  spec.add_dependency "ruby-hmac"
  spec.add_dependency "addressable"

  spec.add_development_dependency('pry')
  spec.add_development_dependency('pry-nav')
end
