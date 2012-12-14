require 'spec_helper'

describe Newegg do
  
  it %q{should return stores for Newegg.stores} do
    Newegg.stores.should_not be_nil
  end

end #end Newegg
