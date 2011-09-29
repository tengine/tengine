module Tengine::Job::RuntimeAttrs
  extend ActiveSupport::Concern

  included do
    field :phase_cd, :type => Integer
    field :started_at, :type => DateTime
    field :finished_at, :type => DateTime
    field :stopped_at, :type => DateTime
    field :stop_reason, :type => String
  end

end
