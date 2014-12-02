require 'spec_helper'

describe Newegg::Api do
  before(:each) do
    @api = Newegg::Api.new
    FakeWeb.clean_registry
  end

  it %q{throws an error when response is 404} do
    FakeWeb.register_uri(:get, "http://www.ows.newegg.com/Stores.egg/", :status => ["404", "Not Found"])
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
        categories = {
          'Backup Devices & Media' => 2,
          'Barebone / Mini Computers' => 3,
          'CD / DVD / Blu-Ray Burners & Media' => 10,
          'Computer Accessories' => 1,
          'Computer Cases' => 9,
          'CPUs / Processors' => 34,
          'Fans & PC Cooling' => 11,
          'Flash Memory & Readers' => 324,
          'Hard Drives' => 15,
          'Headsets, Speakers, & Soundcards' => 37,
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
          'SSDs' => 119,
          'Video Cards & Video Devices' => 38
        }

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

  it %q{returns success for search(store_id, category_id, sub_category_id, node_id)} do
    response ={"Description" => "Computer Cases", "CategoryType" => 1, "CategoryID" => 7, "StoreID" => 1, "ShowSeeAllDeals" => false, "NodeId" => 7583}
    @api.search(store_id: response["StoreID"], category_id: response["CategoryType"], sub_category_id: response["CategoryID"], node_id: response["NodeId"], page_number: 1)['PaginationInfo']['TotalCount'].should be > 0
  end

  it %q{throws error for search(store_id, category_id, sub_category_id, node_id} do
    FakeWeb.register_uri(:post, %r{http://www.ows.newegg.com/Search.egg/Advanced}, :status => ["404", "Not Found"])
    response = {"Description" => "Computer Cases", "CategoryType" => 1, "CategoryID" => 7, "StoreID" => 1, "ShowSeeAllDeals" => false, "NodeId" => 7583}
    lambda {
      @api.search(store_id: response["StoreID"], category_id: response["CategoryType"], sub_category_id: response["CategoryID"], node_id: response["NodeId"], page_number: 1)
    }.should raise_error Newegg::NeweggClientError
  end

  it %q{throws error for search(store_id, category_id, sub_category_id, node_id} do
    FakeWeb.register_uri(:post, %r{http://www.ows.newegg.com/Search.egg/Advanced}, :status => ["500", "Server"])
    response = {"Description" => "Computer Cases", "CategoryType" => 1, "CategoryID" => 7, "StoreID" => 1, "ShowSeeAllDeals" => false, "NodeId" => 7583}
    lambda {
      @api.search(store_id: response["StoreID"], category_id: response["CategoryType"], sub_category_id: response["CategoryID"], node_id: response["NodeId"], page_number: 1)
    }.should raise_error Newegg::NeweggServerError
  end

  it %q{returns success for search(keywords)} do
    expect(@api.search(keywords: "gtx 770")['PaginationInfo']['TotalCount']).to be > 0
  end

  it %q{returns nil for a NULL search result} do
    expect(@api.search()).to be_nil
  end

  it %q{returns success for specifications} do
    response = {"NeweggItemNumber"=>"N82E16823114051",
                        "Title"=>"RAZER BlackWidow Chroma RZ03-01220200-R3U1 USB Wired Gaming RGB Mechanical Keyboard",
                        "SpecificationGroupList"=> [{
                          "GroupName"=>"Model", "SpecificationPairList"=>[{
                            "Key"=>"Brand", "Value"=>"RAZER"}, {"Key"=>"Name", "Value"=>"BlackWidow Chroma"}, {"Key"=>"Model", "Value"=>"RZ03-01220200-R3U1"}]}, {"GroupName"=>"Spec", "SpecificationPairList"=>[{
                              "Key"=>"Keyboard Interface", "Value"=>"USB"}, {"Key"=>"Design Style", "Value"=>"Gaming"}, {"Key"=>"Mechanical Keyboard", "Value"=>"Yes"}, {"Key"=>"Type", "Value"=>"Wired"}]
                              }]}
    specs = @api.specifications("N82E16823114051")
    expect(specs['SpecificationGroupList'].length).to eq(response['SpecificationGroupList'].length)
    res_group_names = response['SpecificationGroupList'].collect{|s| s['GroupName']}
    specs['SpecificationGroupList'].each{|s| expect(res_group_names).to include s['GroupName']}
  end

end #end Newegg::Api
