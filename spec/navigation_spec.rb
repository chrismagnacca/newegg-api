require 'spec_helper'

describe Newegg::Navigation do
  before(:each) do
    FakeWeb.clean_registry
  end

  it %q{returns success for retrieve(store_id, category_id, node_id)} do
    navigation = Newegg::Navigation.new
    response = {"Description"=> "Backup Devices & Media", "CategoryType"=> 0, "CategoryID"=> 2, "StoreID"=> 1, "ShowSeeAllDeals"=> true, "NodeId"=> 6642}
    navigation.send(:retrieve, response["StoreID"], response["CategoryID"], response["NodeId"]).status.to_i.should == 200
  end
end #end Newegg::Navigation

