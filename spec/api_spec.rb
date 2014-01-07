require 'spec_helper'

describe Newegg::Api do
  before(:each) do
    @api = Newegg::Api.new
    FakeWeb.clean_registry
  end

  it %q{throws an error when response is 404} do
    FakeWeb.register_uri(:get, %r{http://www.ows.newegg.com/Stores.egg/}, :status => ["404", "Not Found"])
    lambda {
      @api.send(:api_get, "Stores.egg")
    }.should raise_error Newegg::NeweggClientError
  end

  it %q{throws an error when response is 404} do
    FakeWeb.register_uri(:get, %r{http://www.ows.newegg.com/Stores.egg/}, :status => ["500", "Server Error"])
    lambda {
      @api.send(:api_get, "Stores.egg")
    }.should raise_error Newegg::NeweggServerError
  end

  it %q{should return an array of Newegg::Store for Newegg::Api.stores} do
    @api.stores.each do |store|
      store.class.should eq(Newegg::Store)
    end
  end

  describe "categories()" do
    subject { @api.categories(store_id) }
    context "with a valid store_id" do
      let(:store_id) { 1 }
      it "should return the correct categories" do
        categories = {'Backup Devices & Media' => 2,
        'Barebone / Mini Computers' => 3,
        'CD / DVD / Blu-Ray Burners & Media' => 10,
        'Computer Accessories' => 1,
        'Computer Cases' => 9,
        'CPUs / Processors' => 34,
        'Fans & PC Cooling' => 11,
        'Flash Memory & Readers' => 324,
        'Hard Drives' => 15,
        'Input Devices' => 29,
        'Keyboards & Mice' => 234,
        'Memory' => 17,
        'Monitors' => 19,
        'Motherboards' => 20,
        'Networking' => 281,
        'Power Protection' => 314,
        'Power Supplies' => 32,
        'Printers / Scanners & Supplies' => 33,
        'Projectors' => 343,
        'Servers & Workstations' => 271,
        'Sound Cards' => 36,
        'Speakers & Headsets' => 37,
        'SSDs' => 119,
        'Video Cards & Video Devices' => 38,
        'Backup Devices & Media' => 2,
        'Barebone / Mini Computers' => 3,
        'CD / DVD / Blu-Ray Burners & Media' => 10,
        'Computer Accessories' => 1,
        'Computer Cases' => 9,
        'CPUs / Processors' => 34,
        'Fans & PC Cooling' => 11,
        'Flash Memory & Readers' => 324,
        'Hard Drives' => 15,
        'Input Devices' => 29,
        'Keyboards & Mice' => 234,
        'Memory' => 17,
        'Monitors' => 19,
        'Motherboards' => 20,
        'Networking' => 281,
        'Power Protection' => 314,
        'Power Supplies' => 32,
        'Printers / Scanners & Supplies' => 33,
        'Projectors' => 343,
        'Servers & Workstations' => 271,
        'Sound Cards' => 36,
        'Speakers & Headsets' => 37,
        'SSDs' => 119,
        'Video Cards & Video Devices' => 38}

        expect(subject.length).to eq(categories.length)
        expect(subject.collect{|c| c.description}).to match_array categories.keys
        expect(subject.collect{|c| c.category_id}).to match_array categories.values
      end

      it "should return the same categories after multiple calls" do
        orig_cats = subject.dup
        @api.categories(@api.stores.last.store_id)
        new_cats = @api.categories(store_id)
        expect(orig_cats.collect{|c| c.description}).to match_array new_cats.collect{|c| c.description}
        expect(orig_cats.collect{|c| c.category_id}).to match_array new_cats.collect{|c| c.category_id}
      end
    end

    context "with an invalid store_id" do
      let(:store_id) { 23123 }
      it "should return an empty array" do
        expect(subject).to be_empty
      end
    end

    context "with a nil store_id" do
      let(:store_id) { nil }
      it "should return an empty array" do
        expect(subject).to be_empty
      end
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

  it %q{returns success for retrieve(store_id, category_id, node_id)} do
    response = {"Description" => "Backup Devices & Media", "CategoryType" => 0, "CategoryID" => 2, "StoreID" => 1, "ShowSeeAllDeals" => true, "NodeId" => 6642}
    @api.navigate(response["StoreID"], response["CategoryID"], response["NodeId"]).should_not be_nil
  end

  it %q{returns success for retrieve(store_id, category_id, sub_category_id, node_id)} do
    response ={"Description" => "Computer Cases", "CategoryType" => 1, "CategoryID" => 7, "StoreID" => 1, "ShowSeeAllDeals" => false, "NodeId" => 7583}
    @api.search(response["StoreID"], response["CategoryType"], response["CategoryID"], response["NodeId"], 1).should_not be_nil
  end

  it %q{throws error for search(store_id, category_id, sub_category_id, node_id} do
    FakeWeb.register_uri(:post, %r{http://www.ows.newegg.com/Search.egg/Advanced}, :status => ["404", "Not Found"])
    response = {"Description" => "Computer Cases", "CategoryType" => 1, "CategoryID" => 7, "StoreID" => 1, "ShowSeeAllDeals" => false, "NodeId" => 7583}
    lambda {
      @api.search(response["StoreID"], response["CategoryType"], response["CategoryID"], response["NodeId"], 1)
    }.should raise_error Newegg::NeweggClientError
  end

  it %q{throws error for search(store_id, category_id, sub_category_id, node_id} do
    FakeWeb.register_uri(:post, %r{http://www.ows.newegg.com/Search.egg/Advanced}, :status => ["500", "Server"])
    response = {"Description" => "Computer Cases", "CategoryType" => 1, "CategoryID" => 7, "StoreID" => 1, "ShowSeeAllDeals" => false, "NodeId" => 7583}
    lambda {
      @api.search(response["StoreID"], response["CategoryType"], response["CategoryID"], response["NodeId"], 1)
    }.should raise_error Newegg::NeweggServerError
  end

  it %q{returns success for specifications} do
    response = {"NeweggItemNumber" => "N82E16823201044", "Title" => "Rosewill Mechanical Keyboard RK-9000RE with Cherry MX Red Switch", "SpecificationGroupList" =>
            [{"GroupName" => "Model", "SpecificationPairList" => [{"Key" => "Brand", "Value" => "Rosewill"}, {"Key" => "Model", "Value" => "RK-9000RE"}]}, {"GroupName" => "Keyboard Connection Type", "SpecificationPairList" =>
            [{"Key" => "Keyboard Interface", "Value" => "USB and PS/2"}]}, {"GroupName" => "Keyboard SPEC", "SpecificationPairList" => [{"Key" => "Design Style", "Value" => "Gaming"}, {"Key" => "Palm Rest", "Value" => "N/A"},
                                                                                                                                        {"Key" => "Normal Keys", "Value" => "104"}, {"Key" => "Keyboard Color", "Value" => "Black"},
                                                                                                                                        {"Key" => "Dimensions", "Value" => "17.32\" x 5.43\" x 1.52\""}]}, {"GroupName" => "Type", "SpecificationPairList" =>
            [{"Key" => "Type", "Value" => "Wired"}]}, {"GroupName" => "Mouse Included", "SpecificationPairList" => [{"Key" => "Mouse Included", "Value" => "No"}]}, {"GroupName" => "OS / System Requirement", "SpecificationPairList" =>
            [{"Key" => "Operating System Supported", "Value" => "Windows XP/ Vista/ 7/ 8"}, {"Key" => "System Requirement", "Value" => "1 x USB Port or PS/2 port"}]}, {"GroupName" => "Features", "SpecificationPairList" => [{"Key" => "Features", "Value" =>
            "Highly durable professional gaming keyboard\n\nExtremely responsive and accurate for hours of comfortable gaming\n\nGaming-grade lifetime: 50 million clicks\n\nDurable red metal inner chassis\n\nN-Key rollover: 104 Key could press at the same time, avoid any key jamming (Only PS2 mode, at USB Mode 6-key rollover)\n\nCherry Red Switches: linear feeling with light operating force, 50 million life cycle of the switch, comfortable typing for long term use, fast response on each key.\n\nLaser printing design for the keycap\n\nGold plated USB and PS/2 connector to ensure low latency\n\nHigh quality braided cable\n\nSpec for Cherry MX Red Switch: \nTotal Travel: 4.0-0.4 mm\nKey Stroke: 4.0+/-0.5 mm\nKey pitch: 19.05mm\nOperating Force: 2.0+/-0.5 oz\nLife Cycle: 50 x 10^6 Times"}]}, {"GroupName" => "Packaging", "SpecificationPairList" => [{"Key" => "Package Contents", "Value" => "Keyboard\nUser manual"}]}, {"GroupName" => "Manufacturer Warranty", "SpecificationPairList" => [{"Key" => "Parts", "Value" => "3 years limited"}, {"Key" => "Labor", "Value" => "1 year limited"}]}]}

    specs = @api.specifications("N82E16823201044")
    expect(specs['SpecificationGroupList'].length).to eq(response['SpecificationGroupList'].length)
    res_group_names = response['SpecificationGroupList'].collect{|s| s['GroupName']}
    specs['SpecificationGroupList'].each{|s| expect(res_group_names).to include s['GroupName']}
  end

end #end Newegg::Api
