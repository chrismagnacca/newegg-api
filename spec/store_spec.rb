require 'spec_helper'

describe Newegg::Store do

  it %q{should return a Newegg::Category for Newegg::Store.new(title, store_department, store_id, show_see_all_deals)} do
    title = "Computer Hardware"
    store_department = "ComputerHardware"
    store_id = 1
    show_see_all_deals = true

    store = Newegg::Store.new(title, store_department, store_id, show_see_all_deals)

    store.title.should  eq("Computer Hardware")
    store.store_department.should eq("ComputerHardware")
    store.store_id.should eq(1)
    store.show_see_all_deals.should eq(true)
  end

  it %q{should return store information when .to_h is called on a Newegg::Store} do
    response = {:description=>"Backup Devices & Media", :category_type=>0, :category_id=>2, :store_id=>1, :node_id=>6642}
    store = Newegg.stores.first
    Newegg.categories(store.store_id).count.should eq(23)
    Newegg.categories(store.store_id).first.to_h.should eq(response)
  end

  it %q{should return Newegg::Categories when .get_categories is called on a Newegg::Store} do
    categories = Newegg.stores.first.get_categories
    categories.should_not be_nil
    categories.count.should eq(23)
  end
end #end Newegg::Store
