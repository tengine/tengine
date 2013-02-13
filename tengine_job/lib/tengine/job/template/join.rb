# -*- coding: utf-8 -*-
require 'tengine/job/template'

# 複数のVertexの終了を待ちあわせて一つのVertexへSignalを通知する合流のVertex。
class Tengine::Job::Template::Join < Tengine::Job::Junction
end
