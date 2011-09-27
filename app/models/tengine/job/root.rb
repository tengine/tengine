module Tengine::Job::Root
  extend ActiveSupport::Concern

  included do
    field :dsl_version, :type => String
    field :lock_version, :type => Integer
  end
end
