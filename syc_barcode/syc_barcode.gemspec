$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "syc_barcode/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "syc_barcode"
  s.version     = SycBarcode::VERSION
  s.authors     = ["Pierre Sugar"]
  s.email       = ["pierre@sugaryourcoffee.de"]
  s.homepage    = "syc.dyndns.org"
  s.summary     = "Barcode creator"
  s.description = "Creates a barcode and adds it to a pdf file using Prawn"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"

  s.add_development_dependency "sqlite3"
end
