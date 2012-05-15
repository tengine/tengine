module Tengine::Job::MmCompatibility::Connectable
  extend ActiveSupport::Concern

  included do
    alias_method :vm_instance_name , :server_name
    alias_method :vm_instance_name=, :server_name=
    alias_method :instance_name , :server_name
    alias_method :instance_name=, :server_name=
    alias_method :user_group_credential_name , :credential_name
    alias_method :user_group_credential_name=, :credential_name=
  end

end
