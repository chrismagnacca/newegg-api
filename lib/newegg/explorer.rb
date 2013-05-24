module Newegg
  module Explorer
    require 'newegg/api'
    
    def api
      @api ||= Api.new
    end
    
    def method_missing(method, *args, &block)
      return self.api.send(method) if args.empty?
      self.api.send(method, *args)
    end
    
    def respond_to?(method)
      return true if (self.methods.include?(method) || self.instance_methods.include?(method))
      false
    end
    
  end
end