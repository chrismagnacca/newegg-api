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

end #end Newegg::Store
