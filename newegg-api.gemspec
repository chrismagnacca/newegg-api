# -*- encoding: utf-8 -*-
require File.expand_path('../lib/newegg/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = %q{newegg-api}
  spec.version       = Newegg::VERSION

  spec.authors       = ['Chris Magnacca']
  spec.email         = %w{'chrismagnacca@gmail.com'}
  spec.description   = %q{this gem allows the usage of the newegg.com api to ascertain product information.}
  spec.summary       = %q{newegg's json api}
  spec.homepage      = %q{http://github.com/chrismagnacca/newegg-api}

  spec.files         = %w{
                        Gemfile
                        Gemfile.lock
                        LICENSE
                        README.md
                        Rakefile
                        lib/
                        lib/newegg.rb
                        lib/newegg/api.rb
                        lib/newegg/category.rb
                        lib/newegg/error.rb
                        lib/newegg/store.rb
                        lib/newegg/explorer.rb
                        lib/newegg/version.rb
                        spec/api_spec.rb
                        spec/category_spec.rb
                        spec/spec_helper.rb
                        spec/newegg_spec.rb
                        spec/store_spec.rb
                        newegg-api.gemspec
                        }

  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']
  spec.add_dependency(%q<json>,['~>1.7'])
  spec.add_dependency(%q<faraday>,['~>0.8'])
  spec.add_development_dependency(%q<simplecov>)
  spec.add_development_dependency(%q<fakeweb>,['~>1.3'])
  spec.add_development_dependency(%q<rspec>,['~>2.11'])
  spec.add_development_dependency(%q<rake>, ['~>10.0.4'])
  spec.add_development_dependency(%q<coveralls>, ['~>0.6'])
end
