class Tengine::Job::JobnetActual < Tengine::Job::Jobnet
  include Tengine::Job::RuntimeAttrs
  field :was_expansion, :type => Boolean
end
