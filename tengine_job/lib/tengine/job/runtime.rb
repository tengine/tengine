require 'tengine/job'

module Tengine::Job::Runtime

  autoload :Vertex              , "tengine/job/runtime/vertex"
  autoload :Edge                , "tengine/job/runtime/edge"

  autoload :NamedVertex         , "tengine/job/runtime/named_vertex"

  autoload :Jobnet              , "tengine/job/runtime/jobnet"
  autoload :Start               , "tengine/job/runtime/jobnet"
  autoload :End                 , "tengine/job/runtime/jobnet"

  autoload :Junction            , "tengine/job/runtime/junction"
  autoload :Fork                , "tengine/job/runtime/junction"
  autoload :Join                , "tengine/job/runtime/junction"

  autoload :RootJobnet          , "tengine/job/runtime/root_jobnet"

  autoload :SshJob              , "tengine/job/runtime/ssh_job"


  autoload :Executable          , "tengine/job/runtime/executable"
  autoload :Execution           , "tengine/job/runtime/execution"
  autoload :JobnetActual        , "tengine/job/runtime/jobnet_actual"
  autoload :RootJobnetActual    , "tengine/job/runtime/root_jobnet_actual"
  autoload :ScriptExecutable    , "tengine/job/runtime/script_executable"
  autoload :Signal              , 'tengine/job/runtime/runtime/signal'
  autoload :Stoppable           , "tengine/job/runtime/stoppable"

end
