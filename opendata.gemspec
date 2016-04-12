# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opendata'

Gem::Specification.new do |spec|
  spec.name          = "arcgis-opendata"
  spec.version       = Opendata::VERSION
  spec.authors       = ["Alexander Harris"]
  spec.email         = ["alexander_harris@esri.com"]

  spec.summary       = %q{Ruby Client for the ArcGIS Open Data API.}
  spec.description   = %q{Ruby Client for the ArcGIS Open Data API built on top of Faraday.}
  spec.homepage      = "https://github.com/esridc/arcgis-opendata.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.8.11"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.10.3"
end
