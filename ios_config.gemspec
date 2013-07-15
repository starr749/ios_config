# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ios_config/version'

Gem::Specification.new do |spec|
  spec.name          = "ios_config"
  spec.version       = IOSConfig::VERSION
  spec.authors       = ["Taylor Boyko"]
  spec.email         = ["taylorboyko@gmail.com"]
  spec.description   = %q{Generate configuration profiles and payloads for Apple iOS devices}
  spec.summary       = %q{This gen provides an easy way to generate profiles and configuration payloads for use with Apple iOS devices. These profiles and payloads can be delivered via Apple MDM or Apple's Configurator or iPhone Configuration Utility (IPCU).}
  spec.homepage      = "https://github.com/tboyko/ios_config"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "CFPropertyList", "~> 2.2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
