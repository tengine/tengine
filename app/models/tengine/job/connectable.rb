module Tengine::Job::Connectable
  extend ActiveSupport::Concern

  included do
    field :server_name, :type => String
    field :credential_name, :type => String

    include Tengine::Job::MmCompatibility::Connectable
  end
end
