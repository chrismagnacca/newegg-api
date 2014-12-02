module Newegg
  class Api
    UserAgents = {
        iPhone: 'Newegg iPhone App / 4.3.1',
        Android: 'Newegg Android App / 3.3.3'
    }
    DefaultUserAgent = :iPhone

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
    # retrieves store content
    #
    def store_content(store_id, category_id = -1, node_id = -1, store_type = 4, page_number = 1)
      params = {
          'storeId'    => store_id,
          'categoryId' => category_id,
          'nodeId'     => node_id,
          'storeType'  => store_type,
          'pageNumber' => page_number
      }
      JSON.parse(api_get('Stores.egg', 'Content', nil, params).body)
    end

    #
    # retrieves stores
    #
    def shop_all_navigation
      JSON.parse(api_get('Store.egg', 'ShopAllNavigation').body)
    end

    def shop_more_navigation
      JSON.parse(api_get('Store.egg', 'MoreNavigation').body)
    end

    #
    # retrieves information necessary to search for products, given the store_id, category_id, node_id
    #
    # @param [Integer] store_id of the store
    # @param [Integer] category_id of the store
    # @param [Integer] node_id of the store
    # @param [Integer] store_type of the store
    #
    def store_navigate(store_id, category_id = -1, node_id = -1, store_type = 4)
      params = {
          'storeId'    => store_id,
          'categoryId' => category_id,
          'nodeId'     => node_id,
          'storeType'  => store_type
      }
      JSON.parse(api_get('Store.egg', 'storeNavigation', nil, params).body)
    end

    #
    # retrieves a single page of products given a query specified by an options hash. See options below.
    # node_id, page_number, and an optional sorting method
    #
    # @param [Integer] store_id, from @api.navigation, returned as StoreID
    # @param [Integer] category_id from @api.navigation, returned as CategoryType
    # @param [Integer] sub_category_id from @api.navigation, returned as CategoryID
    # @param [Integer] node_id from @api.navigation, returned as NodeId
    # @param [Integer] page_number of the paginated search results, returned as PaginationInfo from search
    # @param [String] sort style of the returned search results, default is FEATURED (can also be RATING, PRICE, PRICED, REVIEWS)
    # @param [String] keywords
    #
    def search(options={})
      options = {store_id: -1, category_id: -1, sub_category_id: -1, node_id: -1, page_number: 1, sort: "FEATURED",
                 keywords: ""}.merge(options)
      request = {
          'IsUPCCodeSearch'      => false,
          'IsSubCategorySearch'  => options[:sub_category_id] > 0,
          'isGuideAdvanceSearch' => false,
          'StoreDepaId'          => options[:store_id],
          'CategoryId'           => options[:category_id],
          'SubCategoryId'        => options[:sub_category_id],
          'NodeId'               => options[:node_id],
          'BrandId'              => -1,
          'NValue'               => "",
          'Keyword'              => options[:keywords],
          'Sort'                 => options[:sort],
          'PageNumber'           => options[:page_number]
      }

      JSON.parse(api_post("Search.egg", "Advanced", request).body, {quirks_mode: true})
    end

    #
    # retrieves a single page of products given a query specified by an options hash. See options below.
    #
    # @param [Array] brand_list
    # @param [Array] search_properties
    # @param [String] keyword
    # @param [String] max_price
    # @param [String] min_price
    # @param [String] nvalue
    # @param [Array] product_type
    # @param [Integer] page_number
    # @param [Integer] node_id
    # @param [Integer] category_id
    # @param [Integer] brand_id
    # @param [Integer] store_id
    # @param [Integer] store_type
    # @param [Integer] sub_category_id
    #
    def query(options={})
      options = {brand_list: [], search_properties: [], keyword: '', max_price:'', min_price: '', nvalue: '', product_type: [],
                 page_number: 1, node_id: -1, category_id: -1, brand_id: -1, store_id: -1, store_type: -1, sub_category_id: -1}.merge(options)
      request = {
          'BrandList'        => options[:brand_list],
          'SearchProperties' => options[:search_properties],
          'Keyword'          => options[:keyword],
          'MaxPrice'         => options[:max_price],
          'MinPrice'         => options[:min_price],
          'NValue'           => options[:nvalue],
          'ProductType'      => options[:product_type],
          'PageNumber'       => options[:page_number],
          'NodeId'           => options[:node_id],
          'CategoryId'       => options[:category_id],
          'BrandId'          => options[:brand_id],
          'StoreId'          => options[:store_id],
          'StoreType'        => options[:store_type],
          'SubCategoryId'    => options[:sub_category_id]
      }

      JSON.parse(api_post('Search.egg', 'Query', request).body, {quirks_mode: true})
    end

    #
    # retrieve power search content given an category
    #
    # @param [Integer] category_id
    #
    def power_search_content(category_id)
      JSON.parse(api_get('PowerSearchContent.egg', '0', "#{category_id}/-1").body)
    end

    #
    # retrieves a single page of products given a query specified by an options hash. See options below.
    #
    # @param [Array] search_properties
    # @param [Integer] page_number of the paginated power search results
    # @param [Array] product_type
    # @param [String] min_price
    # @param [String] nvalues
    # @param [String] srch_in_desc
    # @param [Array] brand_list
    # @param [String] max_price
    #
    def power_search(search_properties, options={})
      options = {page_number: 1, product_type: [], min_price: '', nvalues: '', srch_in_desc: '',
                 brand_list: [], max_price: ''}.merge(options)
      request = {
          'PageNumber'       => options[:page_number],
          'ProductType'      => options[:product_type],
          'SearchProperties' => search_properties,
          'MinPrice'         => options[:min_price],
          'NValues'          => options[:nvalues],
          'SrchInDesc'       => options[:srch_in_desc],
          'BrandList'        => options[:brand_list],
          'MaxPrice'         => options[:max_price]
      }

      JSON.parse(api_post('PowerSearch.egg', nil, request).body, {quirks_mode: true})
    end

    #
    # retrieve related keywords given an keyword
    #
    # @param [String] item_number of the product
    #
    def keywords(keyword)
      JSON.parse(api_get('AutoKeywords.egg', nil, nil, keyword: keyword).body)
    end

    #
    # retrieve product details given an item number
    #
    # @param [String] item_number of the product
    #
    def details(item_number)
      JSON.parse(api_get('Products.egg', item_number, 'ProductDetails').body)
    end

    #
    # retrieve product information given an item number
    #
    # @param [String] item_number of the product
    #
    def specifications(item_number)
      JSON.parse(api_get("Products.egg", item_number, "Specification").body)
    end

    #
    # retrieve product combo deals given an item number
    #
    # @param [String] item_number of the product
    # @param [Integer] sub_category
    # @param [Integer] sort_field
    # @param [Integer] page_number
    #
    def combo_deals(item_number, options={})
      options = {sub_category: -1, sort_field: 0, page_number: 1}.merge(options)
      params = {
          'SubCategory' => options[:sub_category],
          'SortField'   => options[:sort_field],
          'PageNumber'  => options[:page_number]
      }
      JSON.parse(api_get('Products.egg', item_number, 'ComboDeals', params).body)
    end

    #
    # retrieve product reviews given an item number
    #
    # @param [String] item_number of the product
    # @param [Integer] page_number
    # @param [String] time
    # @param [String] rating default All (can also be 5, 4, 3, 2, 1)
    # @param [String] sort default 'date posted' (can also be 'most helpful', 'highest rated', 'lowest rated', 'ownership')
    #
    def reviews(item_number, page_number = 1, options={})
      options = {time: 'all', rating: 'All', sort: 'date posted'}.merge(options)
      params = {
          'filter.time'   => options[:time],
          'filter.rating' => options[:rating],
          'sort'          => options[:sort]
      }
      JSON.parse(api_get('Products.egg', item_number, "Reviewsinfo/#{page_number}", params).body)
    end

    #
    # retrieve tracking country
    #
    def country
      JSON.parse(api_get('Tracking.egg', 'Country').body)
    end

    #
    # retrieve shopping guide config
    #
    def shopping_guide
      JSON.parse(api_get('Configurations.egg', 'ShoppingGuideConfig').body)
    end

    #
    # retrieve iphone client config
    #
    def client_config
      JSON.parse(api_get('Configurations.egg', 'IphoneClient').body)
    end

    #
    # retrieve exclusive deal item
    #
    def exclusive_deals
      JSON.parse(api_get('Promotions.egg', 'ExclusiveDeals').body)
    end

    #
    # retrieve daily deal
    #
    def daily_deal
      JSON.parse(api_get('Promotions.egg', 'DailyDeal').body)
    end

    #
    # retrieve spotlight item
    #
    def spotlight
      JSON.parse(api_get('Promotions.egg', 'Spotlight').body)
    end

    #
    # retrieve spotlights
    #
    def spotlights
      JSON.parse(api_get('Promotions.egg', 'Spotlights').body)
    end

    #
    # retrieve shell shocker items
    #
    def shell_shockers
      JSON.parse(api_get('Promotions.egg', 'ShellShockers').body)
    end

    #
    # retrieve new shell shocker items
    #
    def shell_shockers_new
      JSON.parse(api_get('Promotions.egg', 'NewShellShocker').body)
    end

    #
    # retrieve banners
    #
    def banners
      JSON.parse(api_get('Promotions.egg', 'Banners').body)
    end

    private

    #
    # GET: {controller}/{action}/{id}/
    #
    # @param [String] controller
    # @param [optional, String] action
    # @param [optional, String] id
    #
    def api_get(controller, action = nil, id = nil, params = {})
      uri = String.new

      if action && id
        uri = "/#{controller}/#{action}/#{id}"
      elsif action
        uri = "/#{controller}/#{action}/"
      else
        uri = "/#{controller}/"
      end

      response = self.connection.get(uri, params) do |request|
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept']       = 'application/json'
        request.headers['User-Agent']  = UserAgents[DefaultUserAgent]
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

    #
    # POST: {controller}/{action}/
    #
    # @param [String] controller
    # @param [String] action
    # @param [Hash] opts
    #
    def api_post(controller, action = nil, opts={})
      uri = String.new
      if action
        uri = "/#{controller}/#{action}/"
      else
        uri = "/#{controller}/"
      end
      response = self.connection.post do |request|
        request.url uri
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept']       = 'application/json'
        request.headers['User-Agent']  = UserAgents[DefaultUserAgent]
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
