# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hg_api/version'

Gem::Specification.new do |spec|
  spec.name          = "hg-api"
  spec.version       = HGAPI::VERSION
  spec.authors       = ["Artyom Keydunov", "Alexey Vakhov"]
  spec.email         = ["artyom.keydunov@uchi.ru", "vakhov@uchi.ru"]
  spec.summary       = %q{Ruby API client for Hosted Graphite.}
  spec.description   = %q{Ruby API client for Hosted Graphite.}
  spec.homepage      = "https://github.com/uchiru/hg-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
