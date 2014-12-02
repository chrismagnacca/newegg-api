require "rspec"
require "fakeweb"
require "net/http"
require "simplecov"
require "coveralls"

# coveralls.io, code coverage, & statistics
Coveralls.wear!
SimpleCov.start

require File.expand_path(File.dirname(__FILE__) + "/../lib/newegg")
