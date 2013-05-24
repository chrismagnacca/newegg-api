require 'spec_helper'

describe Newegg do

  it %q{should return stores for Newegg.stores} do
    Newegg.stores.should_not be_nil
  end

  it %q{should respond to methods properly} do
    Newegg.respond_to?(:api).should be_true
  end

  it %q{should not respond to non-existent methods} do
    Newegg.respond_to?(:wrong).should be_false
  end

  it %q{should pass arguments through method_missing correctly} do
    Newegg.send(:categories, 1).should be_true
  end
end #end Newegg
