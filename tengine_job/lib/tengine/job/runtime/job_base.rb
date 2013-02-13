require 'tengine/job/runtime'

class Tengine::Job::Runtime::JobBase < Tengine::Job::Runtime::NamedVertex
  include Tengine::Job::Runtime::Executable

end
