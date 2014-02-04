# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zendesk_api/version'

Gem::Specification.new do |spec|
  spec.name          = "zendesk_api"
  spec.version       = ZendeskApi::VERSION
  spec.authors       = ["Rafael Bandeira"]
  spec.email         = ["rafaelbandeira3@gmail.com"]
  spec.description   = %q{Zendesk Api client}
  spec.summary       = %q{Work with Zendesk api resources}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
