require File.expand_path('../../../../spec_helper', File.dirname(__FILE__))
require "tengine/support/core_ext/enumerable/map_to_hash"

describe Enumerable do
  describe "#map_to_hash" do

    before(:all) do
      person = Struct.new(:name, :age)
      @alan = person.new("Alan", 10)
      @becky = person.new("Becky", 19)
      @charlie = person.new("Charlie", 50)
    end

    context "map 2 attributes to key and value of Hash" do
      subject{ [@alan, @becky, @charlie].map_to_hash(:name, &:age) }
      it{ should == {"Alan" => 10, "Becky" => 19, "Charlie" => 50} }
    end

    context "map an attribute and element to key and value of Hash" do
      subject{ [@alan, @becky, @charlie].map_to_hash(:name) }
      it{ should == {"Alan" => @alan, "Becky" => @becky, "Charlie" => @charlie} }
    end

    context "raise an UniqueKeyError when duplicated key found" do
      it do
        expect{
          [@alan, @becky, @charlie, @alan].map_to_hash(:name)
        }.to raise_error(Tengine::Support::UniqueKeyError, "duplicated key found: \"Alan\"")
      end
    end

  end
end
