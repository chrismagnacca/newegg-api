module Newegg
  require "json"
  require "faraday"

  require "newegg/api"
  require "newegg/error"
  require "newegg/store"
  require "newegg/version"
  require "newegg/category"
  require "newegg/explorer"
  
  extend Explorer
end
