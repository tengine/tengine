# -*- coding: utf-8 -*-
require 'tengine/job/runtime'

# ルートジョブネットを他のジョブネット内に展開するための特殊なテンプレート用Vertex。
class Tengine::Job::Runtime::SshJob < Tengine::Job::Runtime::JobBase

  include Tengine::Job::Template::SshJob::Settings
  include Tengine::Job::Jobnet::JobStateTransition

end
