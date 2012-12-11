require 'spec_helper'

describe Newegg::Navigation do
  before(:each) do
    @api = Newegg::Api.new
    FakeWeb.clean_registry
  end

  it %q{returns success for retrieve(store_id, category_id, node_id)} do
    response = {"Description"=> "Backup Devices & Media", "CategoryType"=> 0, "CategoryID"=> 2, "StoreID"=> 1, "ShowSeeAllDeals"=> true, "NodeId"=> 6642}
    @api.navigation(response["StoreID"], response["CategoryID"], response["NodeId"]).should_not be_nil
  end
end #end Newegg::Navigation

