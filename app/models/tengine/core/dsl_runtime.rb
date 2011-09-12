# -*- coding: utf-8 -*-
module Tengine::Core::DslRuntime # Kernelにincludeされます

  def safety_processing_headers(headers)
    @ack_called = false
    @processing_headers = headers
    begin
      yield if block_given?
    ensure
      @processing_headers = nil
    end
  end

  def ack_policies
    @ack_policies ||= { }
  end

  def add_ack_policy(event_type_name, policy)
    ack_policies[event_type_name.to_s] = policy.to_sym
  end

  def ack_policy_for(event)
    Tengine.logger.debug("ack_policies: #{ack_policies.inspect}")
    ack_policy = ack_policies[event.event_type_name.to_s] || :at_first
  end

  def ack
    @ack_called = true
    @processing_headers.ack
  end

  def ack?
    @ack_called
  end

end
