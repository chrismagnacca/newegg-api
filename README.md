# Newegg Api

A Ruby Wrapper for the Newegg Mobile API

## Installation

Add this line to your application's Gemfile:

    gem 'newegg'

And then execute:

    $ bundle install

## Usage


#### Retrieve the Current Stores

    response = Newegg::Stores.new.retrieve
    response = [...,
                {"Title": "Computer Hardware",
                 "StoreDepa": "ComputerHardware",
                 "StoreID": 1,
                 "ShowSeeAllDeals": true},
              ...]

#### Retain a StoreID for the desired store

    store_id = stores[...]["StoreID"]


#### Retrieve the Categories for the StoreID

    response = Newegg::Categories.new.retrieve(store_id)

    response = [...,
                    {"Description": "Backup Devices & Media",
                     "CategoryType": 0,
                     "CategoryID": 2,
                     "StoreID": 1,
                     "ShowSeeAllDeals": true,
                     "NodeId": 6642},
                  ...]
##### Retain the StoreID, CategoryID, and NodeId for the category

    store_id = categories[...]["StoreID"]
    category_id = categories[...]["CategoryID"]
    node_id = categories[...]["NodeId"]

#### Retrieve a list of areas under the category

    response = Newegg::Navigation.new.retrieve(store_id, category_id, node_id)

    response = [...,
                    {"Description": "Computer Cases",
                    "CategoryType": 1,
                    "CategoryID": 7,
                    "StoreID": 1,
                    "ShowSeeAllDeals": false,
                    "NodeId": 7583}
                  ,...]

#### Retain the StoreID, CategoryType, CategoryID, and NodeId of the area

    store_id = navigation[...]["StoreID"]
    category_id = navigation[...]["CategoryType"]
    sub_category_id = navigation[...]["CategoryID"]
    node_id = navigation[...]["NodeId"]
    page_number = 1

#### Retrieve a list of all products for the area

    response = Newegg::Search.new.retrieve(store_id, category_id, sub_category_id, node_id, page_number, sort="FEATURED")

    response = {
                "NavigationContentList" => [
                    {"TitleItem" => {"Description" => "Useful Links",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Price",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Manufacturer",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Type",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Color",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Case Material",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "With Power Supply",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Power Supply",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "With Side Panel Window",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "External 5.25\" Drive Bays",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "External 3.5\" Drive Bays",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Power Supply Mounted",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Internal 3.5\" Drive Bays",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Front Ports",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "80mm Fans",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "120mm Fans",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "250mm Fans",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Side Air duct",  "NavigationItemList" => [{...}]},
                    {"TitleItem" => {"Description" => "Expansion Slots", "NavigationItemList" => [{...}]}
                ],

                "RelatedLinkList" => nil,

                "CoremetricsInfo" => {"CategoryID" => "2010090007", ...}

                "IsAllComboBundle" => false,
                "CanBeCompare" => true,
                "MasterComboStoreId" => 0,
                "SubCategoryId" => 7,
                "HasDeactivatedItems" => false,
                "HasHasSimilarItems" => false,
                "SearchProvider" => 0,
                "SearchResultType" => 0,
                "ProductListItems" => [
                        {"Title" => "Antec Three Hundred Illusion Black Steel ATX Mid Tower Computer Case", ...},
                        {"Title" => "COOLER MASTER HAF X RC-942-KKN1 Black Steel/ Plastic ATX Full Tower Computer Case", ...}
                        {"Title" => "Thermaltake VL84301W2Z V3 Black Edition with 430W  Power Supply ATX Mid Tower Computer Case", ...}
                ],
                "PaginationInfo" => {"TotalCount" => 572,
                                     "PageSize" => 20,
                                     "PageNumber" => 1,
                                     "PageCount" => 0}
                }
#### Now you've got all products for the chosen Store, Category, and Sub Category (Area)

    item_number = response["ProductListItems"][*index*]["ItemNumber"]

    response = Newegg::Specifications.new.retrieve(item_number)

    response = {"NeweggItemNumber": "N82E16811147107",
               "Title": "Rosewill BLACKHAWK Gaming ATX Mid Tower Computer Case, come with Five Fans, window side panel, top HDD dock ",
               "SpecificationGroupList": [
               	{
               	    "GroupName": "Model", "SpecificationPairList":
               	        [{"Key": "Brand", "Value": "Rosewill"},
               	         {"Key": "Model","Value": "BlackHawk"}]
                }
               	{"GroupName": "Spec", "SpecificationPairList": [{..}]},
               	{"GroupName": "Expansion", "SpecificationPairList": [{..}]},
               	{"GroupName": "Front Ports", "SpecificationPairList": [{..}]},
               	{"GroupName": "Cooling System", "SpecificationPairList": [{..}]},
               	{"GroupName": "Physical Spec", "SpecificationPairList": [{..}]},
                {"GroupName": "Features", "SpecificationPairList": [{..}]},
                ]
                }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
