# -*- coding: utf-8 -*-
require 'spec_helper'

describe Tengine::Core::DslFilterDef do

  describe :simple_and do
    subject{ Tengine::Core::DslFilterDef.new_and(:foo, :bar) }
    its(:to_method_name){ should == "s_foo_and_bar_e"}
  end

  describe :simple_at do
    subject{ Tengine::Core::DslFilterDef.new_at(:foo, "server1") }
    its(:to_method_name){ should == "s_foo_at_server1_e"}
  end

  describe :complex_and do
    subject{ Tengine::Core::DslFilterDef.new_and(
        Tengine::Core::DslFilterDef.new_at(:foo, "server1"),
        Tengine::Core::DslFilterDef.new_at(:bar, "server2")) }
    its(:to_method_name){ should == "s_s_foo_at_server1_e_and_s_bar_at_server2_e_e"}
  end

  describe :complex_at do
    subject{ Tengine::Core::DslFilterDef.new_at(
        Tengine::Core::DslFilterDef.new_and(:foo, :bar),
        "server1") }
    its(:to_method_name){ should == "s_s_foo_and_bar_e_at_server1_e"}
  end

  describe :complex_at do
    subject{ Tengine::Core::DslFilterDef.new_and(:foo,
        Tengine::Core::DslFilterDef.new_at(:bar, "server1")) }
    its(:to_method_name){ should == "s_foo_and_s_bar_at_server1_e_e"}
  end

end
