module Newegg
  class Search < Api

    #
    # retrieves a single page of products given a specific store_id, category_id, sub_category_id,
    # node_id, page_number, and an optional sorting method. a response from Newegg::Navigation is required.
    #
    # @param [Integer] store_id, from Newegg::Navigation.retrieve(...), returned as StoreID
    # @param [Integer] category_id from Newegg::Navigation.retrieve(...), returned as CategoryType
    # @param [Integer] sub_category_id from Newegg::Navigation.retrieve(...), returned as CategoryID
    # @param [Integer] node_id from Newegg::Navigation.retrieve(...), returned as NodeId
    # @param [Integer] page_number of the paginated search results, returned as PaginationInfo from Newegg::Search.retrieve(...)
    # @param [optional, String] sort style of the returned search results, default is FEATURED
    #
    # @returns [Net::HTTPResponse]
    #
    # @example
    #   response = {"Description"=> "Computer Cases", "CategoryType"=> 1,
    #               "CategoryID"=> 7, "StoreID"=> 1,
    #               "ShowSeeAllDeals"=> false, "NodeId"=> 7583}
    #   Newegg::Search.retrieve(response["StoreID"], response["CategoryType"], response["CategoryID"], response["NodeId"], 1)
    #
    def retrieve(store_id, category_id, sub_category_id, node_id, page_number, sort = "FEATURED")
      request = {
          'IsUPCCodeSearch'      => false,
          'IsSubCategorySearch'  => true,
          'isGuideAdvanceSearch' => false,
          'StoreDepaId'          => store_id,
          'CategoryId'           => category_id,
          'SubCategoryId'        => sub_category_id,
          'NodeId'               => node_id,
          'BrandId'              => -1,
          'NValue'               => "",
          'Keyword'              => "",
          'Sort'                 => sort,
          'PageNumber'           => page_number
      }

      api_post("Search.egg", "Advanced", request)
    end
  end
end