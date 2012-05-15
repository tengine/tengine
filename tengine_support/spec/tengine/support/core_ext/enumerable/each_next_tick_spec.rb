# -*- coding: utf-8 -*-
require File.expand_path('../../../../spec_helper', File.dirname(__FILE__))
require "tengine/support/core_ext/enumerable/each_next_tick"

describe Enumerable do
  describe "#each_next_tick" do
    it "eachと同じ順にiterateする" do
      str = ""
      EM.run do
        [1, 2, 3, 4].each_next_tick do |i|
          str << i.to_s
        end
        EM.add_timer 0.1 do EM.stop end
      end
      str.should == "1234"
    end

    it "next_tickでやる" do
      str = ""
      EM.run do
        [1, 2, 3, 4].each_next_tick do |i|
          str << i.to_s
        end
        str.should be_empty
        EM.add_timer 0.1 do EM.stop end
      end
    end
  end
end
