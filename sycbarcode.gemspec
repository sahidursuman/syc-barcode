# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'syc-barcode'
  s.version = VERSION
  s.author = 'Pierre Sugar'
  s.email = 'pierre@sugaryourcoffee.de'
  s.homepage = 'http://syc.dyndns.org/drupal'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Simple barcode creator'
  s.description = File.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
# Add your other files here if you make them
  s.files = %w(
lib/barcode.rb
lib/checked_attributes.rb
lib/interleave2of5.rb
lib/visual.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--title' << 'sycbarcode' << '--main' << 'README.rdoc' << '-ri'
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_runtime_dependency('prawn')
end
