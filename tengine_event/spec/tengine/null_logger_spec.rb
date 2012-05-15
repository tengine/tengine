# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tengine::NullLogger do
  context "使用可能なメソッド" do
    subject{ Tengine::NullLogger.new }
    it{ subject.debug("foo") }
    it{ subject.info("foo") }
    it{ subject.warn("foo") }
    it{ subject.error("foo") }
    it{ subject.fatal("foo") }
  end
end
