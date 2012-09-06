# -*- coding: utf-8 -*-

require 'tengine_event'

def Tengine::Event.should_fire
  Tengine::Event.should_receive(:fire)
end
