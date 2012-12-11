require 'spec_helper'

describe Newegg::Api do
  before(:each) do
    @api = Newegg::Api.new
    FakeWeb.clean_registry
  end
  
  it %q{throws an error when response is 404} do
    FakeWeb.register_uri(:get, %r{http://www.ows.newegg.com/Stores.egg/}, :status => ["404","Not Found"])
    lambda {
      @api.send(:api_get, "Stores.egg")
    }.should raise_error Newegg::NeweggClientError
  end

  it %q{throws an error when response is 404} do
    FakeWeb.register_uri(:get, %r{http://www.ows.newegg.com/Stores.egg/}, :status => ["500","Server Error"])
    lambda {
      @api.send(:api_get, "Stores.egg")
    }.should raise_error Newegg::NeweggServerError
  end

  it %q{throws an error when response is 404} do
    lambda {
      @api.categories(1)
    }.should raise_error Newegg::ApiError
  end

  it %q{should return an array of Newegg::Store for Newegg::Api.stores} do
    @api.stores.each do |store|
      store.class.should eq(Newegg::Store)
    end
  end
  
  it %q{should return an array of Newegg::Category for Newegg::Api.stores[index].categories} do
    @api.stores.each do |store|
      store.categories.each do |category|
        category.class.should eq(Newegg::Category)
      end
    end
  end
  
  it %q{should return a stores categories for Newegg::Api.stores[index].categories} do
    @api.stores.first.categories.should_not be_nil
    @api.stores.last.categories.should_not be_nil
  end

  it %q{should return categories given a store_id} do
    title = "Computer Hardware"
    store_department = "ComputerHardware"
    store_id = 1
    show_see_all_deals = true
    
    store = Newegg::Store.new(title, store_department, store_id, show_see_all_deals)
    @api.stores # populate the stores for the instance of the api
    categories = @api.categories(store.store_id)
  end
  
  it %q{returns success for retrieve(store_id, category_id, node_id)} do
    response = {"Description"=> "Backup Devices & Media", "CategoryType"=> 0, "CategoryID"=> 2, "StoreID"=> 1, "ShowSeeAllDeals"=> true, "NodeId"=> 6642}
    @api.navigation(response["StoreID"], response["CategoryID"], response["NodeId"]).should_not be_nil
  end
  
  it %q{returns success for retrieve(store_id, category_id, sub_category_id, node_id)} do
    response ={"Description"=> "Computer Cases", "CategoryType"=> 1, "CategoryID"=> 7, "StoreID"=> 1, "ShowSeeAllDeals"=> false, "NodeId"=> 7583}
    @api.search(response["StoreID"], response["CategoryType"], response["CategoryID"], response["NodeId"], 1).should_not be_nil
  end

  it %q{throws error for search(store_id, category_id, sub_category_id, node_id} do
    FakeWeb.register_uri(:post, %r{http://www.ows.newegg.com/Search.egg/Advanced}, :status => ["404","Not Found"])
    response = {"Description"=> "Computer Cases", "CategoryType"=> 1, "CategoryID"=> 7, "StoreID"=> 1, "ShowSeeAllDeals"=> false, "NodeId"=> 7583}
    lambda {
     @api.search(response["StoreID"], response["CategoryType"], response["CategoryID"], response["NodeId"], 1)
    }.should raise_error Newegg::NeweggClientError
  end
  
  it %q{throws error for search(store_id, category_id, sub_category_id, node_id} do
    FakeWeb.register_uri(:post, %r{http://www.ows.newegg.com/Search.egg/Advanced}, :status => ["500","Server"])
    response = {"Description"=> "Computer Cases", "CategoryType"=> 1, "CategoryID"=> 7, "StoreID"=> 1, "ShowSeeAllDeals"=> false, "NodeId"=> 7583}
    lambda {
      @api.search(response["StoreID"], response["CategoryType"], response["CategoryID"], response["NodeId"], 1)
    }.should raise_error Newegg::NeweggServerError
  end
  
end #end Newegg::Api
