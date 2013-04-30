# -*- coding: utf-8 -*-
require 'tengine/job/template'

# ForkやJoinの継承元となるVertex。特に状態は持たない。
class Tengine::Job::Template::Junction < Tengine::Job::Template::Vertex
end

# 一つのVertexから複数のVertexへSignalを通知する分岐のVertex。
class Tengine::Job::Template::Fork < Tengine::Job::Template::Junction
end

# 複数のVertexの終了を待ちあわせて一つのVertexへSignalを通知する合流のVertex。
class Tengine::Job::Template::Join < Tengine::Job::Template::Junction
end
