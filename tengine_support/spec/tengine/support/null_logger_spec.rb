# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Tengine::Support::NullLogger do
  context "使用可能なメソッド" do
    subject{ Tengine::Support::NullLogger.new }
    it{ subject.debug("foo") }
    it{ subject.info("foo") }
    it{ subject.warn("foo") }
    it{ subject.error("foo") }
    it{ subject.fatal("foo") }
  end
end
