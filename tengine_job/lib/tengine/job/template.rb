require 'tengine/job'

module Tengine::Job::Template
  autoload :Vertex              , "tengine/job/template/vertex"
  autoload :NamedVertex         , "tengine/job/template/named_vertex"
  autoload :Jobnet              , "tengine/job/template/jobnet"
  autoload :RootJobnet          , "tengine/job/template/root_jobnet"

  autoload :Connectable         , "tengine/job/template/connectable"

  autoload :Edge                , "tengine/job/template/edge"

  autoload :Start               , "tengine/job/template/start"
  autoload :End                 , "tengine/job/template/end"
  autoload :Junction            , "tengine/job/template/junction"
  autoload :Fork                , "tengine/job/template/fork"
  autoload :Join                , "tengine/job/template/join"


  autoload :Expansion           , "tengine/job/template/expansion"

  autoload :Killing             , "tengine/job/template/killing"

end
