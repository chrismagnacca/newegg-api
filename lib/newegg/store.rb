module Newegg
  class Store < Api
    attr_accessor :title, :store_department, :store_id, :show_see_all_deals
    

    #
    # retrieve a list of available stores from newegg
    #
    # @returns [Net::HTTPResponse]
    #
    # @example
    #   Newegg::Store.retrieve
    #
    def retrieve
      api_get("Stores.egg")
    end

  end
end