module Tengine::Job::RuntimeAttrs
  extend ActiveSupport::Concern

  included do
    field :phase_cd, :type => Integer
    field :started_at, :type => Time
    field :finished_at, :type => Time
    field :stopped_at, :type => Time
    field :stop_reason, :type => String
  end

end
