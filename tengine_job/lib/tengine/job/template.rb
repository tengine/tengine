require 'tengine/job'

module Tengine::Job::Template
  autoload :Vertex              , "tengine/job/template/vertex"
  autoload :Edge                , "tengine/job/template/edge"

  autoload :NamedVertex         , "tengine/job/template/named_vertex"

  autoload :Jobnet              , "tengine/job/template/jobnet"
  autoload :RootJobnet          , "tengine/job/template/root_jobnet"

  autoload :Start               , "tengine/job/template/start"
  autoload :End                 , "tengine/job/template/end"
  autoload :Junction            , "tengine/job/template/junction"
  autoload :Fork                , "tengine/job/template/junction"
  autoload :Join                , "tengine/job/template/junction"

  autoload :SshJob              , "tengine/job/template/ssh_job"

  autoload :Expansion           , "tengine/job/template/expansion"
end
