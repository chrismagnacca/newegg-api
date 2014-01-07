module Newegg
  class Api

    attr_accessor :conn, :_stores, :_categories, :_id

    def initialize
      self._stores = []
    end
    
    #
    # retrieve an active connection or establish a new connection
    #
    # @ returns [Faraday::Connection] conn to the web service
    #
    def connection
      self.conn ||= Faraday.new(:url => 'http://www.ows.newegg.com') do |faraday|
        faraday.request :url_encoded            # form-encode POST params
        faraday.response :logger                # log requests to STDOUT
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
      end      
    end
    
    #
    # retrieve and populate a list of available stores
    #
    def stores
      return self._stores if not self._stores.empty?
      response = api_get("Stores.egg")
      stores = JSON.parse(response.body)
      stores.each do |store|
        self._stores <<  Newegg::Store.new(store['Title'], store['StoreDepa'], store['StoreID'], store['ShowSeeAllDeals'])
      end
      self._stores
    end
    
    #
    # retrieve and populate list of categories for a given store_id
    #
    # @param [Integer] store_id of the store
    #
    def categories(store_id)
      return [] if store_id.nil?

      response = api_get("Stores.egg", "Categories", store_id)
      categories = JSON.parse(response.body)
      categories = categories.collect do |category|
        Newegg::Category.new(category['Description'], category['CategoryType'], category['CategoryID'],
                             category['StoreID'], category['ShowSeeAllDeals'], category['NodeId'])
      end
      
      categories
    end  
    
    #
    # retrieves information necessary to search for products, given the store_id, category_id, node_id
    #
    # @param [Integer] store_id of the store
    # @param [Integer] category_id of the store
    # @param [Integer] node_id of the store
    #
    def navigate(store_id, category_id, node_id)
      response = api_get("Stores.egg", "Navigation", "#{store_id}/#{category_id}/#{node_id}")
      categories = JSON.parse(response.body)
    end
    
    #
    # retrieves a single page of products given a specific store_id, category_id, sub_category_id,
    # node_id, page_number, and an optional sorting method
    #
    # @param [Integer] store_id, from @api.navigation, returned as StoreID
    # @param [Integer] category_id from @api.navigation, returned as CategoryType
    # @param [Integer] sub_category_id from @api.navigation, returned as CategoryID
    # @param [Integer] node_id from @api.navigation, returned as NodeId
    # @param [Integer] page_number of the paginated search results, returned as PaginationInfo from search
    # @param [optional, String] sort style of the returned search results, default is FEATURED
    #
    def search(store_id, category_id, sub_category_id, node_id, page_number, sort = "FEATURED")
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

      JSON.parse(api_post("Search.egg", "Advanced", request).body)
    end
    
    #
    # retrieve product information given an item number
    #
    # @param [String] item_number of the product
    #
    def specifications(item_number)
      JSON.parse(api_get("Products.egg", item_number, "Specification").body)
    end
    
    
    private
    
    #
    # GET: {controller}/{action}/{id}/
    #
    # @param [String] controller
    # @param [optional, String] action
    # @param [optional, String] id
    #
    def api_get(controller, action = nil, id = nil)
      uri = String.new

      if action && id
        uri = "/#{controller}/#{action}/#{id}"
      else
        uri = "/#{controller}/"
      end

      response = self.connection.get(uri)
      
      case code = response.status.to_i
      when 400..499
        raise(Newegg::NeweggClientError, "error, #{code}: #{response.inspect}")
      when 500..599
        raise(Newegg::NeweggServerError, "error, #{code}: #{response.inspect}")
      else
        response
      end
    end

    #
    # POST: {controller}/{action}/
    #
    # @param [String] controller
    # @param [String] action
    # @param [Hash] opts
    #
    def api_post(controller, action, opts={})
      response = self.connection.post do |request|
        request.url "/#{controller}/#{action}/"
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept']       = 'application/json'
        request.headers['Api-Version']  = '2.2'
        request.body = opts.to_json
      end

      case code = response.status.to_i
      when 400..499
        raise(Newegg::NeweggClientError, "error, #{code}: #{response.inspect}")
      when 500..599
        raise(Newegg::NeweggServerError, "error, #{code}: #{response.inspect}")
      else
        response
      end
    end
    
  end
end