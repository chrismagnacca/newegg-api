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
    response = {:title=>"Computer Hardware", :store_department=>"ComputerHardware", :store_id=>1, :show_see_all_deals=>true, :categories=>[{:description=>"Backup Devices & Media", :category_type=>0, :category_id=>2, :store_id=>1, :node_id=>6642}, {:description=>"Barebone / Mini Computers", :category_type=>0, :category_id=>3, :store_id=>1, :node_id=>6668}, {:description=>"CD / DVD / Blu-Ray Burners & Media", :category_type=>0, :category_id=>10, :store_id=>1, :node_id=>6646}, {:description=>"Computer Accessories", :category_type=>0, :category_id=>1, :store_id=>1, :node_id=>6640}, {:description=>"Computer Cases", :category_type=>0, :category_id=>9, :store_id=>1, :node_id=>6644}, {:description=>"CPUs / Processors", :category_type=>0, :category_id=>34, :store_id=>1, :node_id=>6676}, {:description=>"Fans & PC Cooling", :category_type=>0, :category_id=>11, :store_id=>1, :node_id=>6648}, {:description=>"Flash Memory & Readers", :category_type=>0, :category_id=>324, :store_id=>1, :node_id=>6682}, {:description=>"Hard Drives", :category_type=>0, :category_id=>15, :store_id=>1, :node_id=>6670}, {:description=>"Headsets, Speakers, & Soundcards", :category_type=>0, :category_id=>37, :store_id=>1, :node_id=>6660}, {:description=>"Input Devices", :category_type=>0, :category_id=>29, :store_id=>1, :node_id=>6666}, {:description=>"Keyboards & Mice", :category_type=>0, :category_id=>234, :store_id=>1, :node_id=>6690}, {:description=>"Memory", :category_type=>0, :category_id=>17, :store_id=>1, :node_id=>6650}, {:description=>"Monitors", :category_type=>0, :category_id=>19, :store_id=>1, :node_id=>6652}, {:description=>"Motherboards", :category_type=>0, :category_id=>20, :store_id=>1, :node_id=>6654}, {:description=>"Networking", :category_type=>0, :category_id=>281, :store_id=>1, :node_id=>6688}, {:description=>"Power Protection", :category_type=>0, :category_id=>314, :store_id=>1, :node_id=>6674}, {:description=>"Power Supplies", :category_type=>0, :category_id=>32, :store_id=>1, :node_id=>6656}, {:description=>"Printers / Scanners & Supplies", :category_type=>0, :category_id=>33, :store_id=>1, :node_id=>6664}, {:description=>"Projectors", :category_type=>0, :category_id=>343, :store_id=>1, :node_id=>6686}, {:description=>"Servers & Workstations", :category_type=>0, :category_id=>271, :store_id=>1, :node_id=>6684}, {:description=>"SSDs", :category_type=>0, :category_id=>119, :store_id=>1, :node_id=>11692}, {:description=>"Video Cards & Video Devices", :category_type=>0, :category_id=>38, :store_id=>1, :node_id=>6662}]}
    Newegg.stores.first.to_h.should eq(response)
  end

end #end Newegg::Store
