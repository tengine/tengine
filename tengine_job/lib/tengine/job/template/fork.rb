# -*- coding: utf-8 -*-
require 'tengine/job'

# 一つのVertexから複数のVertexへSignalを通知する分岐のVertex。
class Tengine::Job::Fork < Tengine::Job::Junction
end
