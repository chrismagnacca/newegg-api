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

    categories = @api.categories(store.store_id)
  end

end #end Newegg::Api