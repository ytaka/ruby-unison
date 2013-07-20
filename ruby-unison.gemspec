# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unison/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-unison"
  spec.version       = UnisonCommand::VERSION
  spec.authors       = ["Takayuki YAMAGUCHI"]
  spec.email         = ["d@ytak.info"]
  spec.description   = "Ruby interface of the command 'unison'"
  spec.summary       = "Ruby interface of the command of file synchronizer unison (http://www.cis.upenn.edu/~bcpierce/unison/). ruby-unison defines UnisonCommand class to execute unison in ruby script."
  spec.homepage      = "https://github.com/ytaka/ruby-unison"
  spec.license       = "GPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
end
