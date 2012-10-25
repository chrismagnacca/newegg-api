module Newegg
  class Specifications < Api

    #
    # retrieve product information given an item number
    #
    # @param [String] item_number of the product
    #
    # @returns [Net::HTTPResponse]
    #
    # @example
    #   item_number = "11-147-107"
    #   Newegg::Specifications.retrieve(item_number)
    #
    def retrieve(item_number)
      api_get("Products.egg", item_number, "Specification")
    end

  end
end