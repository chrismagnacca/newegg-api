module Newegg
  class Stores < Api

    #
    # retrieve a list of available stores from newegg
    #
    # @returns [Net::HTTPResponse]
    #
    # @example
    #   Newegg::Stores.retrieve
    #
    def retrieve
      api_get("Stores.egg")
    end

  end
end