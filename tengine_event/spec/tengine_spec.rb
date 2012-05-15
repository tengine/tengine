# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'stringio'
require 'logger'

describe Tengine do
  describe :logger do
    it "Tengine.loggerを設定" do
      io = StringIO.new
      Tengine.logger = Logger.new(io)
      Tengine.logger.debug("foo")
      io.rewind
      io.string.should =~ /foo$/
    end
  end
end
