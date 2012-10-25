module Newegg
  class Navigation < Api

    #
    # retrieves information necessary to search for products, given the store_id, category_id, node_id
    #
    # @param [Integer] store_id of the store, returned from Newegg::Categories.retrieve(...) as StoreID
    # @param [Integer] category_id of the store, returned from Newegg::Categories.retrieve(...) as CategoryID
    # @param [Integer] node_id of the store, returned from Newegg::Categories.retrieve(...) as NodeId
    #
    # @returns [Net::HTTPResponse]
    #
    # @example
    #   response = {"Description"=> "Backup Devices & Media",
    #               "CategoryType"=> 0, "CategoryID"=> 2, "StoreID"=> 1, "ShowSeeAllDeals"=> true, "NodeId"=> 6642}
    #   Newegg::Navigation.retrieve(response["StoreID"], response["CategoryID"], response["NodeId"])
    #
    def retrieve(store_id, category_id, node_id)
      api_get("Stores.egg", "Navigation", "#{store_id}/#{category_id}/#{node_id}")
    end

  end
end