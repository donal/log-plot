# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'log-plot/version'

Gem::Specification.new do |spec|
  spec.name          = "log-plot"
  spec.version       = LogPlot::VERSION
  spec.authors       = ["donal"]
  spec.authors       = ["Donal Ellis"]
  spec.email         = ["donal@nashape.com"]

  spec.summary       = %q{Plot requests per period vs time from web server access logs using Gnuplot.}
  spec.description   = %q{Plot requests per period vs time from web server access logs using Gnuplot.}
  spec.homepage      = "https://github.com/donal/log-plot"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('minitest')
  spec.add_development_dependency('minitest-reporters')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('pry-byebug')
end
