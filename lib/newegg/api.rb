module Newegg
  class Api
    BASE_URI = "www.ows.newegg.com"

    protected

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
        uri = "http://#{BASE_URI}/#{controller}/#{action}/#{id}"
      else
        uri = "http://#{BASE_URI}/#{controller}/"
      end

      response = HTTParty.get(uri)
      raise(Newegg::NeweggServerError, "error, #{response.code}: #{response.inspect}") if(response.code > 401)
      response
    end

    #
    # POST: {controller}/{action}/
    #
    # @param [String] controller
    # @param [String] action
    # @param [Hash] opts
    #
    def api_post(controller, action, opts={})
      uri = "http://#{BASE_URI}/#{controller}/#{action}/"
      response = HTTParty.post(uri,
                               :headers => {
                                  'Content-Type'         => 'application/json',
                                  'Accept'               => 'application/json',
                                  'Api-Version'          => '2.2'
                               },
                               :body => opts.to_json)
      raise(Newegg::NeweggServerError, "error, #{response.code}: #{response.inspect}") if(response.code > 401)
      response
    end

  end
end