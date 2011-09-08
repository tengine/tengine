# -*- coding: utf-8 -*-
require 'tengine/core'

Tengine.driver :__connection_test_driver__ do
  on :foo do
    puts "handler foo"
    fire :bar
  end
  on :bar do
    puts "handler bar"
  end
end
