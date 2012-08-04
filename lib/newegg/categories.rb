module Newegg
  class Categories < Api

    #
    # retrieve a list of categories given a store_id. a response from Newegg::Stores.rb is required.
    #
    # @param [Integer] store_id for the categories you wish to retrieve
    #
    # @returns [Net::HTTPResponse]
    #
    # @example
    #   response = {"Title"=> "Computer Hardware","StoreDepa" => "ComputerHardware", "StoreID" => 1,"ShowSeeAllDeals" => true}
    #   Newegg::Categories.retrieve(response["StoreID"])
    #
    def retrieve(store_id)
      api_get("Stores.egg", "Categories", store_id)
    end

  end
end