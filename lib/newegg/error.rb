module Newegg
  class NeweggServerError < StandardError; end
  class NeweggClientError < StandardError; end
  class ApiError < StandardError; end
end