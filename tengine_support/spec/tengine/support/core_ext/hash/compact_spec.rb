# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../../../spec_helper')

require 'active_support'
require "tengine/support/core_ext/hash/compact"

describe Hash do
  describe "#compact!" do
    it "Array#compat!と同じ" do
      h = { :foo => :bar, :baz => nil }
      h.compact!
      h.should include(:foo)
      h.should_not include(:baz)
    end
  end

  describe "#compact" do
    it "非破壊的" do
      h = { :foo => :bar, :baz => nil }
      hh = h.compact
      h.should include(:foo)
      h.should include(:baz)
      hh.should include(:foo)
      hh.should_not include(:baz)
    end
  end
end

