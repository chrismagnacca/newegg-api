module Newegg
  require "json"
  require "log4r"
  require "faraday"

  require "newegg/api"
  require "newegg/error"
  require "newegg/store"
  require "newegg/logger"
  require "newegg/version"
  require "newegg/category"
  require "newegg/explorer"
  
  extend Explorer
end
