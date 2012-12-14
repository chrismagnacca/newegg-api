module Newegg
  module Explorer
    require 'newegg/api'
    
    def api
      @api ||= Api.new
    end
    
    def method_missing(method, *args, &block)
      return self.api.send(method) if args.empty?
      self.api.send(method, args) 
    end
    
  end
end