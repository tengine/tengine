require 'tengine/job'

module Tengine::Job::Template
  autoload :Vertex              , "tengine/job/template/vertex"
  autoload :Edge                , "tengine/job/template/edge"

  autoload :NamedVertex         , "tengine/job/template/named_vertex"

  autoload :Jobnet              , "tengine/job/template/jobnet"
  autoload :Start               , "tengine/job/template/jobnet"
  autoload :End                 , "tengine/job/template/jobnet"

  autoload :Junction            , "tengine/job/template/junction"
  autoload :Fork                , "tengine/job/template/junction"
  autoload :Join                , "tengine/job/template/junction"

  autoload :RootJobnet          , "tengine/job/template/root_jobnet"

  autoload :SshJob              , "tengine/job/template/ssh_job"

  autoload :Expansion           , "tengine/job/template/expansion"

  autoload :Generator           , "tengine/job/template/generator"
end
