require 'spec_helper'

describe Newegg::Category do
  
  it %q{should return a Newegg::Category for Newegg::Category.new(description, category_type, category_id, store_id, show_see_all_deals, node_id)} do
    description = "Backup Devices & Media"
    category_type = 0
    category_id = 2
    store_id = 1
    show_see_all_deals = true
    node_id = 6642
    
    category = Newegg::Category.new(description, category_type, category_id, store_id, show_see_all_deals, node_id)
    
    category.description.should eq("Backup Devices & Media")
    category.category_type.should eq(0)
    category.store_id.should eq(1)
    category.show_see_all_deals.should eq(true)
    category.node_id.should eq(6642)
  end

end #end Newegg::Category
